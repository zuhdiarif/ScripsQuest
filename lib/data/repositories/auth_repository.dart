import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService;

  const AuthRepository(this._authService);

  String _mapError(dynamic e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') || msg.contains('invalid credentials')) {
        return 'Email atau kata sandi salah.';
      }
      if (msg.contains('user already registered') || msg.contains('already exists')) {
        return 'Email sudah terdaftar. Silakan masuk akun.';
      }
      if (msg.contains('password should be at least')) {
        return 'Kata sandi minimal 6 karakter.';
      }
      if (msg.contains('database error saving new user')) {
        return 'Terjadi kendala saat mendaftarkan profil. Silakan coba lagi.';
      }
      return e.message;
    }
    return e.toString().replaceAll('Exception: ', '').replaceAll('AppException: ', '');
  }

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
      throw AuthExceptionWrapper(_mapError(e));
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
      throw AuthExceptionWrapper(_mapError(e));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw AuthExceptionWrapper(_mapError(e));
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
      throw AuthExceptionWrapper(_mapError(e));
    }
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
    OtpType type = OtpType.signup,
  }) async {
    try {
      return await _authService.verifyOtp(
        email: email,
        token: token,
        type: type,
      );
    } catch (e) {
      throw AuthExceptionWrapper(_mapError(e));
    }
  }

  Future<void> resendOtp({
    required String email,
    OtpType type = OtpType.signup,
  }) async {
    try {
      await _authService.resendOtp(
        email: email,
        type: type,
      );
    } catch (e) {
      throw AuthExceptionWrapper(_mapError(e));
    }
  }
}
