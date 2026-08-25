import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService;

  const AuthRepository(this._authService);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      return await _authService.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );
    } catch (e) {
      throw AuthExceptionWrapper(e.toString());
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _authService.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      throw AuthExceptionWrapper(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw AuthExceptionWrapper(e.toString());
    }
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Stream<AuthState> get onAuthStateChange => _authService.onAuthStateChange;

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw AuthExceptionWrapper(e.toString());
    }
  }
}
