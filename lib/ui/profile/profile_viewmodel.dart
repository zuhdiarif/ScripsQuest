import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/models/profile_model.dart';
import 'package:raion_hackjam/data/repositories/profile_repository.dart';
import 'package:raion_hackjam/data/services/storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final StorageService _storageService;

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _profile;
  bool _isEditing = false;

  ProfileViewModel(this._profileRepository, this._storageService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileModel? get profile => _profile;
  bool get isEditing => _isEditing;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.getProfile(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(ProfileModel updatedProfile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.updateProfile(updatedProfile);
      _isEditing = false;
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
