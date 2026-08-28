import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/profile_model.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';
import 'package:raion_hackjam/logic/streak_calculator.dart';
import 'package:raion_hackjam/logic/thesis_curriculum.dart';

class HomeViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;
  final ProfileRepository _profileRepository;

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _profile;
  List<QuestModel> _todayQuests = [];
  int _completedTodayCount = 0;
  int _totalTodayCount = 0;
  int _streakDays = 0;
  List<bool> _weekStreak = List.filled(7, false);

  HomeViewModel(this._questRepository, this._profileRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileModel? get profile => _profile;
  List<QuestModel> get todayQuests => _todayQuests;
  int get completedTodayCount => _completedTodayCount;
  int get totalTodayCount => _totalTodayCount;
  int get streakDays => _profile != null && _profile!.currentStreak > 0
      ? _profile!.currentStreak
      : _streakDays;
  List<bool> get weekStreak => _weekStreak;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadDashboard(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.getProfile(userId);
      _profile = profile;

      final allQuests = await _questRepository.getQuestsByUser(userId);
      _todayQuests = ThesisCurriculum.filterTodayQuests(allQuests);

      _totalTodayCount = _todayQuests.length;
      _completedTodayCount = _todayQuests
          .where((q) => q.status == QuestStatus.completed)
          .length;

      if (_profile != null && _profile!.currentStreak > 0) {
        _streakDays = _profile!.currentStreak;
        _weekStreak = StreakCalculator.calculateWeekStreak(_streakDays);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleQuest(QuestModel quest) async {
    final newStatus = quest.status == QuestStatus.completed
        ? QuestStatus.inProgress
        : QuestStatus.completed;

    try {
      final updated = await _questRepository.updateQuestStatus(quest.id, newStatus);
      final index = _todayQuests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _todayQuests[index] = updated;
        _completedTodayCount = _todayQuests
            .where((q) => q.status == QuestStatus.completed)
            .length;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
