import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:raion_hackjam/ui/achievement/achievement_viewmodel.dart';
import 'package:raion_hackjam/ui/auth/auth_viewmodel.dart';
import 'package:raion_hackjam/ui/guild/guild_viewmodel.dart';
import 'package:raion_hackjam/ui/home/home_viewmodel.dart';
import 'package:raion_hackjam/ui/onboarding/onboarding_viewmodel.dart';
import 'package:raion_hackjam/ui/profile/profile_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_breakdown/quest_breakdown_viewmodel.dart';
import 'package:raion_hackjam/ui/quest_management/quest_management_viewmodel.dart';
import 'package:raion_hackjam/ui/revision_quest/revision_quest_viewmodel.dart';
import 'package:raion_hackjam/ui/streak/streak_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    super.key,
    required this.child,
  });

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
        ChangeNotifierProxyProvider2<GuildRepository, ProfileRepository,
            GuildViewModel>(
          create: (context) => GuildViewModel(
            context.read<GuildRepository>(),
            context.read<ProfileRepository>(),
          ),
          update: (_, guildRepo, profileRepo, prev) =>
              prev ?? GuildViewModel(guildRepo, profileRepo),
        ),
        ChangeNotifierProxyProvider<StreakRepository, StreakViewModel>(
          create: (context) => StreakViewModel(
            context.read<StreakRepository>(),
          ),
          update: (_, streakRepo, prev) =>
              prev ?? StreakViewModel(streakRepo),
        ),
        ChangeNotifierProxyProvider5<ProfileRepository, StorageService,
            JourneyRepository, QuestRepository, BadgeRepository,
            ProfileViewModel>(
          create: (context) => ProfileViewModel(
            context.read<ProfileRepository>(),
            context.read<StorageService>(),
            journeyRepository: context.read<JourneyRepository>(),
            questRepository: context.read<QuestRepository>(),
            badgeRepository: context.read<BadgeRepository>(),
          ),
          update: (_, profileRepo, storageService, journeyRepo, questRepo,
                  badgeRepo, prev) =>
              prev ??
              ProfileViewModel(
                profileRepo,
                storageService,
                journeyRepository: journeyRepo,
                questRepository: questRepo,
                badgeRepository: badgeRepo,
              ),
        ),
      ],
      child: child,
    );
  }
}
