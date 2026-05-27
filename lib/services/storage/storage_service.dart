import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadVisitPhoto(File imageFile, String staffId) async {
    final fileName =
        '${staffId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'visit-photos/$fileName';

    await _supabase.storage.from('visit-photos').upload(
          path,
          imageFile,
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    return _supabase.storage.from('visit-photos').getPublicUrl(path);
  }
}
