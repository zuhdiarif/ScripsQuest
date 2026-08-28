import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';
import 'package:raion_hackjam/data/models/guild_leaderboard_model.dart';
import 'package:raion_hackjam/data/models/guild_model.dart';
import 'package:raion_hackjam/data/repositories/guild_repository.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/logic/guild_code_generator.dart';

class GuildViewModel extends ChangeNotifier {
  final GuildRepository _guildRepository;
  final ProfileRepository? _profileRepository;

  bool _isLoading = false;
  String? _errorMessage;
  GuildModel? _guild;
  List<GuildLeaderboardModel> _leaderboard = [];
  String? _guildCode;
  String _selectedGuildIcon = AppAssets.skullSide;

  GuildViewModel(this._guildRepository, [this._profileRepository]);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GuildModel? get guild => _guild;
  bool get hasGuild => _guild != null;
  List<GuildLeaderboardModel> get leaderboard => _leaderboard;
  List<GuildLeaderboardModel> get members => _leaderboard;
  String? get guildCode => _guild?.code ?? _guildCode;
  String get selectedGuildIcon => _selectedGuildIcon;

  void setSelectedGuildIcon(String iconAsset) {
    _selectedGuildIcon = iconAsset;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> initUserGuild(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_profileRepository != null) {
        final profile = await _profileRepository.getProfile(userId);
        if (profile.guildId != null && profile.guildId!.isNotEmpty) {
          _guild = await _guildRepository.getGuild(profile.guildId!);
          _guildCode = _guild?.code;
          _leaderboard = await _guildRepository.getLeaderboard(profile.guildId!);
        } else {
          _guild = null;
          _guildCode = null;
          _leaderboard = [];
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGuild(
    String name,
    String userId, {
    String? description,
    String? iconUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final code = GuildCodeGenerator.generateCode();
      final newGuild = GuildModel(
        id: '',
        name: name,
        code: code,
        creatorId: userId,
        description: description ?? 'Learn, Connect, and Grow Together',
        iconUrl: iconUrl ?? _selectedGuildIcon,
        createdAt: DateTime.now(),
      );

      _guild = await _guildRepository.createGuild(newGuild);
      _guildCode = _guild?.code;

      if (_guild != null) {
        _leaderboard = await _guildRepository.getLeaderboard(_guild!.id);
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

  Future<bool> joinGuild(String code, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guild = await _guildRepository.joinGuild(userId, code.trim());
      _guildCode = _guild?.code;

      if (_guild != null) {
        _leaderboard = await _guildRepository.getLeaderboard(_guild!.id);
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

  Future<bool> leaveGuild(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _guildRepository.leaveGuild(userId);
      _guild = null;
      _guildCode = null;
      _leaderboard = [];
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

  Future<void> loadGuild(String guildId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guild = await _guildRepository.getGuild(guildId);
      _guildCode = _guild?.code;
      _leaderboard = await _guildRepository.getLeaderboard(guildId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLeaderboard(String guildId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _leaderboard = await _guildRepository.getLeaderboard(guildId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
