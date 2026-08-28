import 'package:go_router/go_router.dart';
import 'package:raion_hackjam/core/constants/app_routes.dart';
import 'package:raion_hackjam/data/models/guild_leaderboard_model.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/ui/achievement/achievement_view.dart';
import 'package:raion_hackjam/ui/auth/auth_view.dart';
import 'package:raion_hackjam/ui/auth/otp_verification_view.dart';
import 'package:raion_hackjam/ui/guild/create_guild_view.dart';
import 'package:raion_hackjam/ui/guild/guild_view.dart';
import 'package:raion_hackjam/ui/guild/join_guild_view.dart';
import 'package:raion_hackjam/ui/guild/member_profile_view.dart';
import 'package:raion_hackjam/ui/home/home_view.dart';
import 'package:raion_hackjam/ui/onboarding/build_quest_view.dart';
import 'package:raion_hackjam/ui/onboarding/onboarding_view.dart';
import 'package:raion_hackjam/ui/profile/profile_view.dart';
import 'package:raion_hackjam/ui/quest_breakdown/quest_breakdown_view.dart';
import 'package:raion_hackjam/ui/quest_management/quest_detail_view.dart';
import 'package:raion_hackjam/ui/quest_management/quest_edit_view.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_view.dart';
import 'package:raion_hackjam/ui/revision_quest/revision_quest_view.dart';
import 'package:raion_hackjam/ui/splash/splash_view.dart';
import 'package:raion_hackjam/ui/streak/streak_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isPublicRoute = AppRoutes.publicRoutes.contains(state.matchedLocation) ||
          state.matchedLocation.startsWith(AppRoutes.buildQuest);
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) {
          final mode = state.uri.queryParameters['mode'];
          final returnTo = state.uri.queryParameters['returnTo'];
          return AuthView(
            initialIsRegister: mode == 'register',
            returnTo: returnTo,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final returnTo = state.uri.queryParameters['returnTo'];
          return OtpVerificationView(
            email: email,
            returnTo: returnTo,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.buildQuest,
        builder: (context, state) {
          final stepStr = state.uri.queryParameters['step'];
          final initialStep = stepStr != null ? int.tryParse(stepStr) ?? 0 : 0;
          return BuildQuestView(initialStep: initialStep);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.questBreakdown,
        builder: (context, state) => const QuestBreakdownView(),
      ),
      GoRoute(
        path: AppRoutes.questManagement,
        builder: (context, state) => const QuestManagementView(),
      ),
      GoRoute(
        path: AppRoutes.questDetail,
        builder: (context, state) {
          final quest = state.extra as QuestModel;
          return QuestDetailView(quest: quest);
        },
      ),
      GoRoute(
        path: AppRoutes.questEdit,
        builder: (context, state) {
          final quest = state.extra as QuestModel?;
          return QuestEditView(quest: quest);
        },
      ),
      GoRoute(
        path: AppRoutes.revisionQuest,
        builder: (context, state) => const RevisionQuestView(),
      ),
      GoRoute(
        path: AppRoutes.achievement,
        builder: (context, state) => const AchievementView(),
      ),
      GoRoute(
        path: AppRoutes.guild,
        builder: (context, state) => const GuildView(),
      ),
      GoRoute(
        path: AppRoutes.createGuild,
        builder: (context, state) => const CreateGuildView(),
      ),
      GoRoute(
        path: AppRoutes.joinGuild,
        builder: (context, state) => const JoinGuildView(),
      ),
      GoRoute(
        path: AppRoutes.memberProfile,
        builder: (context, state) {
          final member = state.extra as GuildLeaderboardModel;
          return MemberProfileView(member: member);
        },
      ),
      GoRoute(
        path: AppRoutes.streak,
        builder: (context, state) => const StreakView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
