import 'package:raion_hackjam/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _client;

  DatabaseService({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  Future<dynamic> select(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    dynamic query = _client.from(table).select();

    if (filters != null && filters.isNotEmpty) {
      query = query.match(Map<String, Object>.from(filters));
    }

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query;
  }

  Future<dynamic> insert(
    String table,
    dynamic data,
  ) async {
    return await _client.from(table).insert(data).select();
  }

  Future<dynamic> update(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> match,
  }) async {
    return await _client
        .from(table)
        .update(data)
        .match(Map<String, Object>.from(match))
        .select();
  }

  Future<dynamic> delete(
    String table, {
    required Map<String, dynamic> match,
  }) async {
    return await _client
        .from(table)
        .delete()
        .match(Map<String, Object>.from(match))
        .select();
  }

  Future<dynamic> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    return await _client.rpc(functionName, params: params);
  }
}
