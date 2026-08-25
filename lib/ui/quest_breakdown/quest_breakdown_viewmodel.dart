import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/goal_model.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';

class QuestBreakdownViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;

  bool _isLoading = false;
  String? _errorMessage;
  GoalModel? _goal;
  final List<QuestModel> _quests = [];

  QuestBreakdownViewModel(this._questRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GoalModel? get goal => _goal;
  List<QuestModel> get quests => List.unmodifiable(_quests);

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setGoal(GoalModel goal) {
    _goal = goal;
    notifyListeners();
  }

  void addQuest(QuestModel quest) {
    final orderedQuest = quest.copyWith(
      questOrder: _quests.length,
      goalId: _goal?.id,
    );
    _quests.add(orderedQuest);
    notifyListeners();
  }

  void removeQuest(int index) {
    if (index >= 0 && index < _quests.length) {
      _quests.removeAt(index);
      for (int i = 0; i < _quests.length; i++) {
        _quests[i] = _quests[i].copyWith(questOrder: i);
      }
      notifyListeners();
    }
  }

  void reorderQuest(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _quests.length) return;
    if (newIndex < 0 || newIndex > _quests.length) return;

    var targetIndex = newIndex;
    if (oldIndex < targetIndex) {
      targetIndex -= 1;
    }

    final quest = _quests.removeAt(oldIndex);
    _quests.insert(targetIndex, quest);

    for (int i = 0; i < _quests.length; i++) {
      _quests[i] = _quests[i].copyWith(questOrder: i);
    }
    notifyListeners();
  }

  void clearQuests() {
    _quests.clear();
    notifyListeners();
  }

  Future<bool> saveQuests() async {
    if (_quests.isEmpty) return true;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      for (int i = 0; i < _quests.length; i++) {
        final quest = _quests[i].copyWith(
          goalId: _goal?.id,
          questOrder: i,
        );
        await _questRepository.createQuest(quest);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
