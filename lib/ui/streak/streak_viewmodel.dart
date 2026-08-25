import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/streak_history_model.dart';
import 'package:raion_hackjam/data/repositories/streak_repository.dart';
import 'package:raion_hackjam/logic/streak_calculator.dart';

class StreakViewModel extends ChangeNotifier {
  final StreakRepository _streakRepository;

  bool _isLoading = false;
  String? _errorMessage;
  int _currentStreak = 0;
  int _longestStreak = 0;
  List<StreakHistoryModel> _streakHistory = [];
  List<DateTime> _weekDays = [];

  StreakViewModel(this._streakRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  List<StreakHistoryModel> get streakHistory => _streakHistory;
  List<DateTime> get weekDays => _weekDays;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  int _calculateLongestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;
    final sorted = dates
        .map((d) => DateTime.utc(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    int maxStreak = 1;
    int current = 1;
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        if (current > maxStreak) {
          maxStreak = current;
        }
      } else if (sorted[i].difference(sorted[i - 1]).inDays > 1) {
        current = 1;
      }
    }
    return maxStreak;
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    _weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  Future<void> loadStreak(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _streakHistory = await _streakRepository.getStreakHistory(userId);
      final activeDates = _streakHistory.map((s) => s.activeDate).toList();
      _currentStreak = StreakCalculator.calculateCurrentStreak(activeDates);
      _longestStreak = _calculateLongestStreak(activeDates);
      _generateWeekDays();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
