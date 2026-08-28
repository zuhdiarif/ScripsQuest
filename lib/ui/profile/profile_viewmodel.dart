import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/badge_model.dart';
import 'package:raion_hackjam/data/models/profile_model.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/models/thesis_journey_model.dart';
import 'package:raion_hackjam/data/models/user_badge_model.dart';
import 'package:raion_hackjam/data/repositories/badge_repository.dart';
import 'package:raion_hackjam/data/repositories/journey_repository.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/data/repositories/quest_repository.dart';
import 'package:raion_hackjam/data/services/storage_service.dart';
import 'package:raion_hackjam/logic/streak_calculator.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final StorageService _storageService;
  final JourneyRepository? journeyRepository;
  final QuestRepository? questRepository;
  final BadgeRepository? badgeRepository;

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _profile;
  ThesisJourneyModel? _journey;
  int _completedQuestsCount = 0;
  int _totalQuestsCount = 0;
  List<BadgeModel> _allBadges = [];
  List<UserBadgeModel> _userBadges = [];
  List<bool> _weekStreak = List.filled(7, false);

  ProfileViewModel(
    this._profileRepository,
    this._storageService, {
    this.journeyRepository,
    this.questRepository,
    this.badgeRepository,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileModel? get profile => _profile;
  ThesisJourneyModel? get journey => _journey;
  int get completedQuestsCount => _completedQuestsCount;
  int get totalQuestsCount => _totalQuestsCount;
  List<BadgeModel> get allBadges => _allBadges;
  List<UserBadgeModel> get userBadges => _userBadges;
  List<bool> get weekStreak => _weekStreak;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.getProfile(userId);

      if (journeyRepository != null) {
        _journey = await journeyRepository!.getActiveJourney(userId);
      }

      if (questRepository != null) {
        final quests = await questRepository!.getQuestsByUser(userId);
        _totalQuestsCount = quests.length;
        _completedQuestsCount =
            quests.where((q) => q.status == QuestStatus.completed).length;
      }

      if (badgeRepository != null) {
        final all = await badgeRepository!.getAllBadges();
        final user = await badgeRepository!.getUserBadges(userId);
        _allBadges = all;
        _userBadges = user;
      }

      _weekStreak = StreakCalculator.calculateWeekStreak(_profile?.currentStreak ?? 0);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUsername(String newUsername) async {
    if (_profile == null) return false;
    final updated = _profile!.copyWith(username: newUsername);
    return updateProfile(updated);
  }

  Future<bool> updateProfile(ProfileModel updatedProfile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.updateProfile(updatedProfile);
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

  Future<bool> uploadAvatar(
    String userId,
    Uint8List fileBytes,
    String fileExt,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final avatarUrl = await _storageService.uploadAvatar(
        userId: userId,
        fileBytes: fileBytes,
        fileExt: fileExt,
      );

      if (_profile != null) {
        final updated = _profile!.copyWith(avatarUrl: avatarUrl);
        _profile = await _profileRepository.updateProfile(updated);
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
