import 'dart:typed_data';
import 'package:raion_hackjam/core/constants/supabase_constants.dart';
import 'package:raion_hackjam/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client;

  StorageService({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List fileBytes,
    required String fileExt,
  }) async {
    final path = '$userId/avatar.$fileExt';
    await _client.storage.from(SupabaseConstants.avatarsBucket).uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );
    return getAvatarUrl(userId, fileExt: fileExt);
  }

  String getAvatarUrl(String userId, {String fileExt = 'png'}) {
    final path = userId.contains('/') ? userId : '$userId/avatar.$fileExt';
    return _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .getPublicUrl(path);
  }

  Future<void> deleteAvatar(String userId, {String fileExt = 'png'}) async {
    final path = userId.contains('/') ? userId : '$userId/avatar.$fileExt';
    await _client.storage.from(SupabaseConstants.avatarsBucket).remove([path]);
  }
}
