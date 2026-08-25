import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:raion_hackjam/core/constants/app_constants.dart';
import 'package:raion_hackjam/core/theme/app_theme.dart';
import 'package:raion_hackjam/data/repositories/auth_repository.dart';
import 'package:raion_hackjam/data/repositories/badge_repository.dart';
import 'package:raion_hackjam/data/repositories/guild_repository.dart';
import 'package:raion_hackjam/data/repositories/journey_repository.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';
import 'package:raion_hackjam/data/repositories/streak_repository.dart';
import 'package:raion_hackjam/data/repositories/xp_repository.dart';
import 'package:raion_hackjam/data/services/auth_service.dart';
import 'package:raion_hackjam/data/services/database_service.dart';
import 'package:raion_hackjam/data/services/storage_service.dart';
import 'package:raion_hackjam/ui/achievement/achievement_view.dart';
import 'package:raion_hackjam/ui/achievement/achievement_viewmodel.dart';
import 'package:raion_hackjam/ui/auth/auth_view.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/guild/guild_view.dart';
import 'package:raion_hackjam/ui/guild/guild_viewmodel.dart';
import 'package:raion_hackjam/ui/home/home_view.dart';
import 'package:raion_hackjam/ui/home/home_viewmodel.dart';
import 'package:raion_hackjam/ui/onboarding/onboarding_view.dart';
import 'package:raion_hackjam/ui/onboarding/onboarding_viewmodel.dart';
import 'package:raion_hackjam/ui/profile/profile_view.dart';
import 'package:raion_hackjam/ui/profile/profile_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_breakdown/quest_breakdown_view.dart';
import 'package:raion_hackjam/ui/quest_breakdown/quest_breakdown_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_view.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/revision_quest/revision_quest_view.dart';
import 'package:raion_hackjam/ui/revision_quest/revision_quest_viewmodel.dart';
import 'package:raion_hackjam/ui/streak/streak_view.dart';
import 'package:raion_hackjam/ui/streak/streak_viewmodel.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthView(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/quest-breakdown',
      builder: (context, state) => const QuestBreakdownView(),
    ),
    GoRoute(
      path: '/quest-management',
      builder: (context, state) => const QuestManagementView(),
    ),
    GoRoute(
      path: '/revision-quest',
      builder: (context, state) => const RevisionQuestView(),
    ),
    GoRoute(
      path: '/achievement',
      builder: (context, state) => const AchievementView(),
    ),
    GoRoute(
      path: '/guild',
      builder: (context, state) => const GuildView(),
    ),
    GoRoute(
      path: '/streak',
      builder: (context, state) => const StreakView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),
  ],
);

class ThesisQuestApp extends StatelessWidget {
  const ThesisQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, _) => AuthRepository(authService),
        ),
        ProxyProvider<DatabaseService, ProfileRepository>(
          update: (_, dbService, _) => ProfileRepository(dbService),
        ),
        ProxyProvider<DatabaseService, JourneyRepository>(
          update: (_, dbService, _) => JourneyRepository(dbService),
        ),
        ProxyProvider<DatabaseService, QuestRepository>(
          update: (_, dbService, _) => QuestRepository(dbService),
        ),
        ProxyProvider<DatabaseService, XpRepository>(
          update: (_, dbService, _) => XpRepository(dbService),
        ),
        ProxyProvider<DatabaseService, BadgeRepository>(
          update: (_, dbService, _) => BadgeRepository(dbService),
        ),
        ProxyProvider<DatabaseService, StreakRepository>(
          update: (_, dbService, _) => StreakRepository(dbService),
        ),
        ProxyProvider<DatabaseService, GuildRepository>(
          update: (_, dbService, _) => GuildRepository(dbService),
        ),
        ChangeNotifierProxyProvider<AuthRepository, AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthRepository>(),
          ),
          update: (_, authRepo, prev) =>
              prev ?? AuthViewModel(authRepo),
        ),
        ChangeNotifierProxyProvider<JourneyRepository, OnboardingViewModel>(
          create: (context) => OnboardingViewModel(
            context.read<JourneyRepository>(),
          ),
          update: (_, journeyRepo, prev) =>
              prev ?? OnboardingViewModel(journeyRepo),
        ),
        ChangeNotifierProxyProvider2<QuestRepository, ProfileRepository,
            HomeViewModel>(
          create: (context) => HomeViewModel(
            context.read<QuestRepository>(),
            context.read<ProfileRepository>(),
          ),
          update: (_, questRepo, profileRepo, prev) =>
              prev ?? HomeViewModel(questRepo, profileRepo),
        ),
        ChangeNotifierProxyProvider<QuestRepository, QuestBreakdownViewModel>(
          create: (context) => QuestBreakdownViewModel(
            context.read<QuestRepository>(),
          ),
          update: (_, questRepo, prev) =>
              prev ?? QuestBreakdownViewModel(questRepo),
        ),
        ChangeNotifierProxyProvider<QuestRepository, QuestManagementViewModel>(
          create: (context) => QuestManagementViewModel(
            context.read<QuestRepository>(),
          ),
          update: (_, questRepo, prev) =>
              prev ?? QuestManagementViewModel(questRepo),
        ),
        ChangeNotifierProxyProvider<QuestRepository, RevisionQuestViewModel>(
          create: (context) => RevisionQuestViewModel(
            context.read<QuestRepository>(),
          ),
          update: (_, questRepo, prev) =>
              prev ?? RevisionQuestViewModel(questRepo),
        ),
        ChangeNotifierProxyProvider2<BadgeRepository, XpRepository,
            AchievementViewModel>(
          create: (context) => AchievementViewModel(
            context.read<BadgeRepository>(),
            context.read<XpRepository>(),
          ),
          update: (_, badgeRepo, xpRepo, prev) =>
              prev ?? AchievementViewModel(badgeRepo, xpRepo),
        ),
        ChangeNotifierProxyProvider<GuildRepository, GuildViewModel>(
          create: (context) => GuildViewModel(
            context.read<GuildRepository>(),
          ),
          update: (_, guildRepo, prev) =>
              prev ?? GuildViewModel(guildRepo),
        ),
        ChangeNotifierProxyProvider<StreakRepository, StreakViewModel>(
          create: (context) => StreakViewModel(
            context.read<StreakRepository>(),
          ),
          update: (_, streakRepo, prev) =>
              prev ?? StreakViewModel(streakRepo),
        ),
        ChangeNotifierProxyProvider2<ProfileRepository, StorageService,
            ProfileViewModel>(
          create: (context) => ProfileViewModel(
            context.read<ProfileRepository>(),
            context.read<StorageService>(),
          ),
          update: (_, profileRepo, storageService, prev) =>
              prev ?? ProfileViewModel(profileRepo, storageService),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
