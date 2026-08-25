import 'package:flutter/material.dart';
import 'package:raion_hackjam/app.dart';
import 'package:raion_hackjam/data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const ThesisQuestApp());
}
