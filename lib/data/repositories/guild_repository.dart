import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/core/errors/exceptions.dart';
import 'package:raion_hackjam/data/models/guild_leaderboard_model.dart';
import 'package:raion_hackjam/data/models/guild_model.dart';
import 'package:raion_hackjam/data/services/database_service.dart';

class GuildRepository {
  final DatabaseService _databaseService;

  const GuildRepository(this._databaseService);

  Future<GuildModel> createGuild(GuildModel guild) async {
    try {
      final response = await _databaseService.insert(
        SupabaseConstants.guildsTable,
        guild.toJson(),
      );

      final createdGuild = GuildModel.fromJson(
        response.first as Map<String, dynamic>,
      );

      await _databaseService.update(
        SupabaseConstants.profilesTable,
        {'guild_id': createdGuild.id},
        match: {'id': guild.creatorId},
      );

      return createdGuild;
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<GuildModel> joinGuild(String userId, String code) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.guildsTable,
        filters: {'code': code.toUpperCase()},
      );

      if (response == null || (response as List).isEmpty) {
        throw NotFoundException('Guild with code $code not found');
      }

      final guild = GuildModel.fromJson(
        response.first as Map<String, dynamic>,
      );

      await _databaseService.update(
        SupabaseConstants.profilesTable,
        {'guild_id': guild.id},
        match: {'id': userId},
      );

      return guild;
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<void> leaveGuild(String userId) async {
    try {
      await _databaseService.update(
        SupabaseConstants.profilesTable,
        {'guild_id': null},
        match: {'id': userId},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<GuildModel> getGuild(String guildId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.guildsTable,
        filters: {'id': guildId},
      );

      if (response == null || (response as List).isEmpty) {
        throw NotFoundException('Guild not found: $guildId');
      }

      return GuildModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<GuildModel> getGuildByCode(String code) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.guildsTable,
        filters: {'code': code.toUpperCase()},
      );

      if (response == null || (response as List).isEmpty) {
        throw NotFoundException('Guild with code $code not found');
      }

      return GuildModel.fromJson(
        response.first as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<List<GuildLeaderboardModel>> getLeaderboard(String guildId) async {
    try {
      final response = await _databaseService.select(
        SupabaseConstants.guildLeaderboardView,
        filters: {'guild_id': guildId},
        orderBy: 'rank',
        ascending: true,
      );

      if (response == null) return [];

      return (response as List)
          .map((json) =>
              GuildLeaderboardModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
