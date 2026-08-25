CREATE TYPE thesis_stage AS ENUM (
  'belum_mulai','menentukan_topik','proposal','seminar_proposal',
  'literature_review','pengumpulan_data','analisis_data',
  'penulisan','revisi','persiapan_sidang'
);

CREATE TYPE journey_status AS ENUM ('active','completed');
CREATE TYPE quest_status AS ENUM ('not_started','in_progress','completed');
CREATE TYPE quest_type AS ENUM ('regular','revision');

CREATE TABLE public.guilds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  creator_id uuid NOT NULL REFERENCES auth.users(id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE NOT NULL,
  avatar_url text,
  total_xp integer NOT NULL DEFAULT 0,
  level integer NOT NULL DEFAULT 1,
  current_streak integer NOT NULL DEFAULT 0,
  longest_streak integer NOT NULL DEFAULT 0,
  last_active_date date,
  guild_id uuid REFERENCES public.guilds(id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.thesis_journeys (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  stage thesis_stage NOT NULL,
  topic text,
  current_goal text NOT NULL,
  status journey_status NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  journey_id uuid NOT NULL REFERENCES public.thesis_journeys(id) ON DELETE CASCADE,
  title text NOT NULL,
  thesis_stage thesis_stage NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.quests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  goal_id uuid REFERENCES public.goals(id) ON DELETE CASCADE,
  parent_quest_id uuid REFERENCES public.quests(id),
  type quest_type NOT NULL DEFAULT 'regular',
  title text NOT NULL,
  description text,
  feedback_note text,
  status quest_status NOT NULL DEFAULT 'not_started',
  quest_order integer DEFAULT 0,
  xp_reward integer NOT NULL DEFAULT 10,
  deadline date,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);

CREATE TABLE public.xp_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quest_id uuid REFERENCES public.quests(id) ON DELETE SET NULL,
  xp_amount integer NOT NULL,
  reason text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  requirement text NOT NULL,
  icon_url text
);

CREATE TABLE public.user_badges (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_id uuid NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
  unlocked_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, badge_id)
);

CREATE TABLE public.streak_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  active_date date NOT NULL,
  UNIQUE (user_id, active_date)
);

CREATE VIEW public.guild_leaderboard AS
SELECT
  p.guild_id,
  p.id AS user_id,
  p.username,
  p.avatar_url,
  p.level,
  p.total_xp,
  rank() OVER (PARTITION BY p.guild_id ORDER BY p.total_xp DESC) AS rank
FROM public.profiles p
WHERE p.guild_id IS NOT NULL;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thesis_journeys ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.xp_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.streak_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guilds ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own journeys" ON public.thesis_journeys
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own journeys" ON public.thesis_journeys
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own journeys" ON public.thesis_journeys
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own goals" ON public.goals
  FOR SELECT USING (
    journey_id IN (SELECT id FROM public.thesis_journeys WHERE user_id = auth.uid())
  );
CREATE POLICY "Users can insert own goals" ON public.goals
  FOR INSERT WITH CHECK (
    journey_id IN (SELECT id FROM public.thesis_journeys WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can view own quests" ON public.quests
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own quests" ON public.quests
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own quests" ON public.quests
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own quests" ON public.quests
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own xp logs" ON public.xp_logs
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view own badges" ON public.user_badges
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view own streak" ON public.streak_history
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view guilds they belong to" ON public.guilds
  FOR SELECT USING (
    id IN (SELECT guild_id FROM public.profiles WHERE id = auth.uid())
    OR creator_id = auth.uid()
  );
CREATE POLICY "Users can create guilds" ON public.guilds
  FOR INSERT WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Guild members can view leaderboard profiles" ON public.profiles
  FOR SELECT USING (
    guild_id IN (SELECT guild_id FROM public.profiles WHERE id = auth.uid())
  );

CREATE OR REPLACE FUNCTION public.handle_quest_completed()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    NEW.completed_at = now();

    INSERT INTO public.xp_logs (user_id, quest_id, xp_amount, reason)
    VALUES (NEW.user_id, NEW.id, NEW.xp_reward, 'quest_completed');

    UPDATE public.profiles
    SET total_xp = total_xp + NEW.xp_reward,
        level = CASE
          WHEN total_xp + NEW.xp_reward >= 1000 THEN 5
          WHEN total_xp + NEW.xp_reward >= 500 THEN 4
          WHEN total_xp + NEW.xp_reward >= 250 THEN 3
          WHEN total_xp + NEW.xp_reward >= 100 THEN 2
          ELSE 1
        END
    WHERE id = NEW.user_id;

    INSERT INTO public.streak_history (user_id, active_date)
    VALUES (NEW.user_id, CURRENT_DATE)
    ON CONFLICT (user_id, active_date) DO NOTHING;

    UPDATE public.profiles
    SET last_active_date = CURRENT_DATE,
        current_streak = (
          SELECT COUNT(*)
          FROM (
            SELECT active_date,
                   active_date - (ROW_NUMBER() OVER (ORDER BY active_date DESC))::int AS grp
            FROM public.streak_history
            WHERE user_id = NEW.user_id
          ) sub
          WHERE grp = (
            SELECT active_date - (ROW_NUMBER() OVER (ORDER BY active_date DESC))::int
            FROM public.streak_history
            WHERE user_id = NEW.user_id
            ORDER BY active_date DESC
            LIMIT 1
          )
        ),
        longest_streak = GREATEST(longest_streak, current_streak)
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_quest_completed
  BEFORE UPDATE ON public.quests
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_quest_completed();

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || LEFT(NEW.id::text, 8)));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
