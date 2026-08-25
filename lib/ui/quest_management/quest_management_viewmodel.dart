import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';

class QuestManagementViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<QuestModel> _quests = [];
  String _selectedFilter = 'all';

  QuestManagementViewModel(this._questRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<QuestModel> get quests => _quests;
  String get selectedFilter => _selectedFilter;

  List<QuestModel> get filteredQuests {
    switch (_selectedFilter) {
      case 'active':
        return _quests
            .where((q) =>
                q.status == QuestStatus.notStarted ||
                q.status == QuestStatus.inProgress)
            .toList();
      case 'completed':
        return _quests
            .where((q) => q.status == QuestStatus.completed)
            .toList();
      case 'all':
      default:
        return _quests;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void filterQuests(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> loadQuests(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _quests = await _questRepository.getQuestsByUser(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuestStatus(String questId, QuestStatus status) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedQuest = await _questRepository.updateQuestStatus(
        questId,
        status,
      );

      final index = _quests.indexWhere((q) => q.id == questId);
      if (index != -1) {
        _quests[index] = updatedQuest;
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

  Future<bool> deleteQuest(String questId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _questRepository.deleteQuest(questId);
      _quests.removeWhere((q) => q.id == questId);
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
