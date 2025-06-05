import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://vribqwdjfgonhhyngjtv.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyaWJxd2RqZmdvbmhoeW5nanR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0NTkzMDIsImV4cCI6MjA1NzAzNTMwMn0.5O5qCCqzXZqaF7zMoWlpXVKvT9NVdmTJrRtRF6MDQMs';

  static final supabase = Supabase.instance.client;
}
