import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/thesis_journey_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class JourneyRepository {
  final DatabaseService _databaseService;

  const JourneyRepository(this._databaseService);

  Future<ThesisJourneyModel?> getActiveJourney(String userId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.thesisJourneysTable,
        filters: {
          'user_id': userId,
          'status': JourneyStatus.active.value,
        },
        orderBy: 'created_at',
        ascending: false,
        limit: 1,
      );

      if (response == null || (response as List).isEmpty) {
        return null;
      }

      return ThesisJourneyModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<ThesisJourneyModel> createJourney(ThesisJourneyModel journey) async {
    try {
      final response = await _databaseService.insert(
        SupabaseConstants.thesisJourneysTable,
        journey.toJson(),
      );

      if (response == null || (response as List).isEmpty) {
        throw DatabaseException('Failed to create journey: empty response');
      }

      return ThesisJourneyModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<ThesisJourneyModel> updateJourney(ThesisJourneyModel journey) async {
    try {
      final response = await _databaseService.update(
        SupabaseConstants.thesisJourneysTable,
        journey.toJson(),
        match: {'id': journey.id},
      );

      if (response == null || (response as List).isEmpty) {
        throw DatabaseException('Failed to update journey: empty response');
      }

      return ThesisJourneyModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
