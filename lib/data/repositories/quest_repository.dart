import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class QuestRepository {
  final DatabaseService _databaseService;

  const QuestRepository(this._databaseService);

  Future<List<QuestModel>> getQuestsByGoal(String goalId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.questsTable,
        filters: {'goal_id': goalId},
        orderBy: 'quest_order',
        ascending: true,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => QuestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<List<QuestModel>> getQuestsByUser(
    String userId, {
    QuestStatus? status,
  }) async {
    try {
      final filters = <String, dynamic>{'user_id': userId};
      if (status != null) {
        filters['status'] = status.value;
      }

      final response = await _databaseService.select(
        SupabaseConstants.questsTable,
        filters: filters,
        orderBy: 'quest_order',
        ascending: true,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => QuestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<QuestModel> createQuest(QuestModel quest) async {
    try {
      final response = await _databaseService.insert(
        SupabaseConstants.questsTable,
        quest.toJson(),
      );

      return QuestModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<QuestModel> updateQuest(QuestModel quest) async {
    try {
      final response = await _databaseService.update(
        SupabaseConstants.questsTable,
        quest.toJson(),
        match: {'id': quest.id},
      );

      return QuestModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<void> deleteQuest(String questId) async {
    try {
      await _databaseService.delete(
        SupabaseConstants.questsTable,
        match: {'id': questId},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<QuestModel> updateQuestStatus(
    String questId,
    QuestStatus status,
  ) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.value,
        'completed_at': status == QuestStatus.completed
            ? DateTime.now().toIso8601String()
            : null,
      };

      final response = await _databaseService.update(
        SupabaseConstants.questsTable,
        updateData,
        match: {'id': questId},
      );

      return QuestModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
