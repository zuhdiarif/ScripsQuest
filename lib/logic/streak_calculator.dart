class StreakCalculator {
  const StreakCalculator._();

  static int calculateCurrentStreak(List<DateTime> activeDates) {
    if (activeDates.isEmpty) return 0;

    final uniqueDates = activeDates
        .map((d) => DateTime.utc(d.year, d.month, d.day))
        .toSet();

    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (uniqueDates.contains(today)) {
      int streak = 0;
      var checkDate = today;
      while (uniqueDates.contains(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
      return streak;
    } else if (uniqueDates.contains(yesterday)) {
      int streak = 0;
      var checkDate = yesterday;
      while (uniqueDates.contains(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
      return streak;
    }

    return 0;
  }

  static bool isStreakActive(DateTime? lastActiveDate) {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime.utc(
      lastActiveDate.year,
      lastActiveDate.month,
      lastActiveDate.day,
    );
    return dateOnly == today || dateOnly == yesterday;
  }

  static List<bool> calculateWeekStreak(int streakCount) {
    final activeDays = streakCount.clamp(0, 7);
    return List.generate(7, (index) => index < activeDays);
  }
}
