import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/guild_leaderboard_model.dart';
import 'package:raion_hackjam/data/models/guild_model.dart';
import 'package:raion_hackjam/data/repositories/guild_repository.dart';

class GuildViewModel extends ChangeNotifier {
  final GuildRepository _guildRepository;

  bool _isLoading = false;
  String? _errorMessage;
  GuildModel? _guild;
  List<GuildLeaderboardModel> _leaderboard = [];
  String? _guildCode;

  GuildViewModel(this._guildRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GuildModel? get guild => _guild;
  List<GuildLeaderboardModel> get leaderboard => _leaderboard;
  String? get guildCode => _guildCode;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    final suffix = List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    return 'THESIS-$suffix';
  }

  Future<bool> createGuild(String name, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newGuild = GuildModel(
        id: '',
        name: name,
        code: _generateCode(),
        creatorId: userId,
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
    try {
      _leaderboard = await _guildRepository.getLeaderboard(guildId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
