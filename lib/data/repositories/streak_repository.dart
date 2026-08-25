import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/streak_history_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class StreakRepository {
  final DatabaseService _databaseService;

  const StreakRepository(this._databaseService);

  Future<List<StreakHistoryModel>> getStreakHistory(
    String userId, {
    int? days,
  }) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.streakHistoryTable,
        filters: {'user_id': userId},
        orderBy: 'active_date',
        ascending: false,
        limit: days,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) =>
              StreakHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<StreakHistoryModel> recordActiveDay(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateString = date.toIso8601String().split('T').first;
      final response = await _databaseService.insert(
        SupabaseConstants.streakHistoryTable,
        {
          'user_id': userId,
          'active_date': dateString,
        },
      );

      return StreakHistoryModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
