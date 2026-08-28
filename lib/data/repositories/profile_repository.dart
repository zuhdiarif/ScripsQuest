import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/profile_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class ProfileRepository {
  final DatabaseService _databaseService;

  const ProfileRepository(this._databaseService);

  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.profilesTable,
        filters: {'id': userId},
      );

      if (response == null || (response as List).isEmpty) {
        throw NotFoundException('Profile not found for user: $userId');
      }

      return ProfileModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      final response = await _databaseService.insert(
        SupabaseConstants.profilesTable,
        profile.toJson(),
      );

      if (response == null || (response as List).isEmpty) {
        throw DatabaseException('Failed to create profile: empty response');
      }

      return ProfileModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await _databaseService.update(
        SupabaseConstants.profilesTable,
        profile.toJson(),
        match: {'id': profile.id},
      );

      if (response == null || (response as List).isEmpty) {
        throw DatabaseException('Failed to update profile: empty response');
      }

      return ProfileModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
