import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/badge_model.dart';
import 'package:raion_hackjam/data/models/user_badge_model.dart';
import 'package:raion_hackjam/data/repositories/badge_repository.dart';
import 'package:raion_hackjam/data/repositories/xp_repository.dart';
import 'package:raion_hackjam/logic/level_calculator.dart';

class AchievementViewModel extends ChangeNotifier {
  final BadgeRepository _badgeRepository;
  final XpRepository _xpRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<BadgeModel> _badges = [];
  List<UserBadgeModel> _userBadges = [];
  int _totalXp = 0;
  int _level = 1;

  AchievementViewModel(this._badgeRepository, this._xpRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BadgeModel> get badges => _badges;
  List<UserBadgeModel> get userBadges => _userBadges;
  int get totalXp => _totalXp;
  int get level => _level;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadAchievements(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final badgesFuture = _badgeRepository.getAllBadges();
      final userBadgesFuture = _badgeRepository.getUserBadges(userId);
      final xpFuture = _xpRepository.getTotalXp(userId);

      final results = await Future.wait([
        badgesFuture,
        userBadgesFuture,
        xpFuture,
      ]);

      _badges = results[0] as List<BadgeModel>;
      _userBadges = results[1] as List<UserBadgeModel>;
      _totalXp = results[2] as int;
      _level = LevelCalculator.calculateLevel(_totalXp);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
