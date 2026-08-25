import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/xp_log_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class XpRepository {
  final DatabaseService _databaseService;

  const XpRepository(this._databaseService);

  Future<List<XpLogModel>> getXpLogs(String userId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.xpLogsTable,
        filters: {'user_id': userId},
        orderBy: 'created_at',
        ascending: false,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => XpLogModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<int> getTotalXp(String userId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.profilesTable,
        filters: {'id': userId},
      );

      if (response == null || (response as List).isEmpty) {
        return 0;
      }

      final profileMap = response.first as Map<String, dynamic>;
      return (profileMap['total_xp'] as num?)?.toInt() ?? 0;
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
