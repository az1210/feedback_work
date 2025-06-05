import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://mjihvwihowhvxvxbiwie.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qaWh2d2lob3dodnh2eGJpd2llIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxNDMyMDEsImV4cCI6MjA2MTcxOTIwMX0.vlpJjRWvFuxtEnDA06qqVjXQ0fal544If_o9wcN9xo0';

  static final supabase = Supabase.instance.client;
}
