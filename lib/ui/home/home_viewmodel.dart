import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/profile_model.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;
  final ProfileRepository _profileRepository;

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _profile;
  List<QuestModel> _activeQuests = [];
  int _completedQuestsCount = 0;

  HomeViewModel(this._questRepository, this._profileRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileModel? get profile => _profile;
  List<QuestModel> get activeQuests => _activeQuests;
  int get completedQuestsCount => _completedQuestsCount;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadDashboard(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profileFuture = _profileRepository.getProfile(userId);
      final questsFuture = _questRepository.getQuestsByUser(userId);

      final results = await Future.wait([profileFuture, questsFuture]);

      _profile = results[0] as ProfileModel;
      final allQuests = results[1] as List<QuestModel>;

      _activeQuests = allQuests
          .where((q) =>
              q.status == QuestStatus.inProgress ||
              q.status == QuestStatus.notStarted)
          .toList();

      _completedQuestsCount = allQuests
          .where((q) => q.status == QuestStatus.completed)
          .length;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
