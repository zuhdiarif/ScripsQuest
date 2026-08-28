import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/badge_model.dart';
import 'package:raion_hackjam/data/models/user_badge_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class BadgeRepository {
  final DatabaseService _databaseService;

  const BadgeRepository(this._databaseService);

  Future<List<BadgeModel>> getAllBadges() async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.badgesTable,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => BadgeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<List<UserBadgeModel>> getUserBadges(String userId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.userBadgesTable,
        filters: {'user_id': userId},
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => UserBadgeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<UserBadgeModel> unlockBadge(String userId, String badgeId) async {
    try {
      final response = await _databaseService.insert(
        SupabaseConstants.userBadgesTable,
        {
          'user_id': userId,
          'badge_id': badgeId,
          'unlocked_at': DateTime.now().toIso8601String(),
        },
      );

      if (response == null || (response as List).isEmpty) {
        throw DatabaseException('Failed to unlock badge: empty response');
      }

      return UserBadgeModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
