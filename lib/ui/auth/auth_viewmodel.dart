import 'package:flutter/foundation.dart';
import 'package:raion_hackjam/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthViewModel(this._authRepository) {
    checkAuthStatus();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void checkAuthStatus() {
    _currentUser = _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.signIn(
        email: email,
        password: password,
      );
      _currentUser = response.user;
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

  Future<bool> signUp(
    String email,
    String password, {
    String? username,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );
      _currentUser = response.user;
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

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
