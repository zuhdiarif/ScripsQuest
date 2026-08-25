class LevelCalculator {
  const LevelCalculator._();

  static int _thresholdForLevel(int level) {
    if (level <= 1) return 0;
    if (level == 2) return 100;
    if (level == 3) return 250;
    if (level == 4) return 500;
    if (level == 5) return 1000;
    int currentXp = 1000;
    double delta = 500.0;
    for (int l = 6; l <= level; l++) {
      delta = (delta * 1.5).roundToDouble();
      currentXp += delta.toInt();
    }
    return currentXp;
  }

  static int calculateLevel(int totalXp) {
    if (totalXp < 0) return 1;
    int level = 1;
    while (_thresholdForLevel(level + 1) <= totalXp) {
      level++;
    }
    return level;
  }

  static int xpForNextLevel(int currentLevel) {
    if (currentLevel < 1) return _thresholdForLevel(2);
    return _thresholdForLevel(currentLevel + 1);
  }

  static double progressToNextLevel(int totalXp) {
    if (totalXp < 0) return 0.0;
    final currentLevel = calculateLevel(totalXp);
    final currentLevelThreshold = _thresholdForLevel(currentLevel);
    final nextLevelThreshold = xpForNextLevel(currentLevel);
    final neededXp = nextLevelThreshold - currentLevelThreshold;
    if (neededXp <= 0) return 1.0;
    final progress = (totalXp - currentLevelThreshold) / neededXp;
    return progress.clamp(0.0, 1.0);
  }
}
