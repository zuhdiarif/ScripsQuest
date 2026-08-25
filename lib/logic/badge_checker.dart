class BadgeChecker {
  const BadgeChecker._();

  static List<String> checkUnlockableBadges({
    required int totalXp,
    required int questsCompleted,
    required int currentStreak,
    required List<String> alreadyUnlocked,
  }) {
    final unlockedSet = alreadyUnlocked.toSet();
    final newBadges = <String>[];

    void check(String badgeId, bool condition) {
      if (condition && !unlockedSet.contains(badgeId)) {
        newBadges.add(badgeId);
      }
    }

    check('first_quest', questsCompleted >= 1);
    check('quest_5', questsCompleted >= 5);
    check('quest_10', questsCompleted >= 10);
    check('quest_25', questsCompleted >= 25);
    check('quest_50', questsCompleted >= 50);

    check('streak_3', currentStreak >= 3);
    check('streak_7', currentStreak >= 7);
    check('streak_14', currentStreak >= 14);
    check('streak_30', currentStreak >= 30);

    check('xp_100', totalXp >= 100);
    check('xp_500', totalXp >= 500);
    check('xp_1000', totalXp >= 1000);
    check('xp_2500', totalXp >= 2500);
    check('xp_5000', totalXp >= 5000);

    return newBadges;
  }
}
