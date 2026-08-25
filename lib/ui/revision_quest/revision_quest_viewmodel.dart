import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';

class RevisionQuestViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;

  bool _isLoading = false;
  String? _errorMessage;
  String _feedbackNote = '';
  final List<String> _subtasks = [];

  RevisionQuestViewModel(this._questRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get feedbackNote => _feedbackNote;
  List<String> get subtasks => List.unmodifiable(_subtasks);

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setFeedback(String note) {
    _feedbackNote = note;
    notifyListeners();
  }

  void addSubtask(String subtask) {
    if (subtask.trim().isNotEmpty) {
      _subtasks.add(subtask.trim());
      notifyListeners();
    }
  }

  void removeSubtask(int index) {
    if (index >= 0 && index < _subtasks.length) {
      _subtasks.removeAt(index);
      notifyListeners();
    }
  }

  void reset() {
    _feedbackNote = '';
    _subtasks.clear();
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveRevisionQuest({
    required String userId,
    required String title,
    String? goalId,
    String? description,
    DateTime? deadline,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final parentQuest = QuestModel(
        id: '',
        userId: userId,
        goalId: goalId,
        type: QuestType.revision,
        title: title,
        description: description,
        feedbackNote: _feedbackNote.isEmpty ? null : _feedbackNote,
        status: QuestStatus.notStarted,
        questOrder: 0,
        xpReward: 20,
        deadline: deadline,
        createdAt: DateTime.now(),
      );

      final createdParent = await _questRepository.createQuest(parentQuest);

      for (int i = 0; i < _subtasks.length; i++) {
        final subtaskQuest = QuestModel(
          id: '',
          userId: userId,
          goalId: goalId,
          parentQuestId: createdParent.id,
          type: QuestType.revision,
          title: _subtasks[i],
          status: QuestStatus.notStarted,
          questOrder: i,
          xpReward: 10,
          createdAt: DateTime.now(),
        );
        await _questRepository.createQuest(subtaskQuest);
      }

      reset();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
