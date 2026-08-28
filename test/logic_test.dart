import 'package:flutter_test/flutter_test.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/logic/badge_checker.dart';
import 'package:raion_hackjam/logic/guild_code_generator.dart';
import 'package:raion_hackjam/logic/level_calculator.dart';
import 'package:raion_hackjam/logic/streak_calculator.dart';
import 'package:raion_hackjam/logic/thesis_curriculum.dart';
import 'package:raion_hackjam/logic/xp_calculator.dart';

void main() {
  group('XpCalculator', () {
    test('returns correct xp for regular quest', () {
      expect(XpCalculator.xpForQuest(QuestType.regular), 10);
    });

    test('returns correct xp for revision quest', () {
      expect(XpCalculator.xpForQuest(QuestType.revision), 20);
    });

    test('returns correct xp for checkpoint', () {
      expect(XpCalculator.xpForCheckpoint(), 50);
    });
  });

  group('LevelCalculator', () {
    test('calculates correct levels for xp thresholds', () {
      expect(LevelCalculator.calculateLevel(0), 1);
      expect(LevelCalculator.calculateLevel(50), 1);
      expect(LevelCalculator.calculateLevel(100), 2);
      expect(LevelCalculator.calculateLevel(249), 2);
      expect(LevelCalculator.calculateLevel(250), 3);
      expect(LevelCalculator.calculateLevel(500), 4);
      expect(LevelCalculator.calculateLevel(1000), 5);
      expect(LevelCalculator.calculateLevel(1750), 6);
    });

    test('returns next level xp threshold', () {
      expect(LevelCalculator.xpForNextLevel(1), 100);
      expect(LevelCalculator.xpForNextLevel(2), 250);
      expect(LevelCalculator.xpForNextLevel(3), 500);
      expect(LevelCalculator.xpForNextLevel(4), 1000);
    });

    test('calculates progress to next level', () {
      expect(LevelCalculator.progressToNextLevel(0), 0.0);
      expect(LevelCalculator.progressToNextLevel(50), 0.5);
      expect(LevelCalculator.progressToNextLevel(100), 0.0);
      expect(LevelCalculator.progressToNextLevel(175), 0.5);
    });
  });

  group('StreakCalculator', () {
    test('returns 0 for empty list', () {
      expect(StreakCalculator.calculateCurrentStreak([]), 0);
    });

    test('calculates streak from today', () {
      final now = DateTime.now();
      final dates = [
        now,
        now.subtract(const Duration(days: 1)),
        now.subtract(const Duration(days: 2)),
      ];
      expect(StreakCalculator.calculateCurrentStreak(dates), 3);
    });

    test('calculates streak from yesterday', () {
      final now = DateTime.now();
      final dates = [
        now.subtract(const Duration(days: 1)),
        now.subtract(const Duration(days: 2)),
      ];
      expect(StreakCalculator.calculateCurrentStreak(dates), 2);
    });

    test('checks if streak is active', () {
      final now = DateTime.now();
      expect(StreakCalculator.isStreakActive(now), isTrue);
      expect(
        StreakCalculator.isStreakActive(now.subtract(const Duration(days: 1))),
        isTrue,
      );
      expect(
        StreakCalculator.isStreakActive(now.subtract(const Duration(days: 2))),
        isFalse,
      );
      expect(StreakCalculator.isStreakActive(null), isFalse);
    });

    test('calculates week streak indicators', () {
      final streak3 = StreakCalculator.calculateWeekStreak(3);
      expect(streak3, [true, true, true, false, false, false, false]);

      final streak7 = StreakCalculator.calculateWeekStreak(10);
      expect(streak7, [true, true, true, true, true, true, true]);

      final streak0 = StreakCalculator.calculateWeekStreak(0);
      expect(streak0, [false, false, false, false, false, false, false]);
    });
  });

  group('BadgeChecker', () {
    test('unlocks badges based on criteria and ignores already unlocked', () {
      final unlocked = BadgeChecker.checkUnlockableBadges(
        totalXp: 550,
        questsCompleted: 6,
        currentStreak: 4,
        alreadyUnlocked: ['first_quest', 'xp_100'],
      );

      expect(unlocked.contains('quest_5'), isTrue);
      expect(unlocked.contains('streak_3'), isTrue);
      expect(unlocked.contains('xp_500'), isTrue);
      expect(unlocked.contains('first_quest'), isFalse);
      expect(unlocked.contains('xp_100'), isFalse);
      expect(unlocked.contains('xp_1000'), isFalse);
    });
  });

  group('ThesisCurriculum', () {
    test('generates 14 sequential thesis quests', () {
      final quests = ThesisCurriculum.generateInitialThesisQuests('user_123');
      expect(quests.length, 14);
      expect(quests.first.title, 'Menentukan Topik & Masalah Penelitian');
      expect(quests.last.title, 'Sidang Akhir Skripsi & Yudisium');
      expect(quests.first.questOrder, 1);
      expect(quests.last.questOrder, 14);
    });

    test('filters today quests correctly', () {
      final quests = ThesisCurriculum.generateInitialThesisQuests('user_123');
      final today = ThesisCurriculum.filterTodayQuests(quests, limit: 4);
      expect(today.length, 2);
      expect(today.every((q) => q.status == QuestStatus.inProgress), isTrue);
    });

    test('calculates thesis progress ratio correctly', () {
      expect(ThesisCurriculum.calculateThesisProgress(0, 14), 0.0);
      expect(ThesisCurriculum.calculateThesisProgress(7, 14), 0.5);
      expect(ThesisCurriculum.calculateThesisProgress(14, 14), 1.0);
      expect(ThesisCurriculum.calculateThesisProgress(20, 14), 1.0);
      expect(ThesisCurriculum.calculateThesisProgress(5, 0), 0.0);
    });
  });

  group('GuildCodeGenerator', () {
    test('generates valid code format starting with S-', () {
      final code = GuildCodeGenerator.generateCode();
      expect(code.startsWith('S-'), isTrue);
      expect(GuildCodeGenerator.isValidCode(code), isTrue);
    });

    test('validates valid and invalid guild codes', () {
      expect(GuildCodeGenerator.isValidCode('S-AB1234'), isTrue);
      expect(GuildCodeGenerator.isValidCode('S-XY9876'), isTrue);
      expect(GuildCodeGenerator.isValidCode('AB1234'), isFalse);
      expect(GuildCodeGenerator.isValidCode(''), isFalse);
    });
  });
}
