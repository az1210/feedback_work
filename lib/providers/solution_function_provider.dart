import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

// StateNotifier to manage the percentage value
class PercentageNotifier extends StateNotifier<int> {
  PercentageNotifier() : super(0); // Initial value is 0%

  // Method to reset the percentage to 0
  void reset() {
    state = 0;
  }
}

// Define the provider for percentage state
final percentageProvider =
    StateNotifierProvider<PercentageNotifier, int>((ref) {
  return PercentageNotifier();
});

// Provider for managing start time
final startTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Provider for managing end time
final endTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().add(const Duration(minutes: 2));
});

// Provider for managing break time
final breakTimeProvider = StateProvider<Duration>((ref) {
  return const Duration(minutes: 1); // Default break time is 1 minute
});

// Provider for managing travel percentage per hour
final travelPerHourProvider =
    StateProvider<double>((ref) => 50.0); // Default: 50%

// Provider for managing travel percentage per minute
final travelPerMinuteProvider =
    StateProvider<double>((ref) => 0.833); // Default: 50/60

// StateNotifier to manage all settings as a single entity
class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  final supabase = Supabase.instance.client;

  SettingsNotifier()
      : super({
          'startTime': DateTime.now(),
          'endTime': DateTime.now().add(const Duration(minutes: 2)),
          'breakTime': const Duration(minutes: 1),
          'travelPerHour': 50.0,
          'travelPerMinute': 0.833,
          'audioUrl': null,
          'popupText': null,
        });

  // Update individual settings
  void updateSetting(String key, dynamic value) {
    state = {...state, key: value};
  }

  // Reset all settings to default
  void resetSettings() {
    state = {
      'startTime': DateTime.now(),
      'endTime': DateTime.now().add(const Duration(minutes: 2)),
      'breakTime': const Duration(minutes: 1),
      'travelPerHour': 50.0,
      'travelPerMinute': 0.833,
      'audioUrl': null,
      'popupText': null,
    };
  }

  // Save settings to Supabase
  Future<void> saveSettings(String projectId) async {
    try {
      final settingsData = {
        'startTime': (state['startTime'] as DateTime).toIso8601String(),
        'endTime': (state['endTime'] as DateTime).toIso8601String(),
        'breakTime': (state['breakTime'] as Duration).inMinutes,
        'travelPerHour': state['travelPerHour'],
        'travelPerMinute': state['travelPerMinute'],
        'audioUrl': state['audioUrl'],
        'popupText': state['popupText'],
      };

      await supabase.from('projects').update(
          {'solution_function_settings': settingsData}).eq('id', projectId);
    } catch (e) {
      throw Exception("Failed to save settings: ${e.toString()}");
    }
  }

  // Upload audio file to Supabase Storage
  Future<String> uploadAudio(File audioFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp3';
      await supabase.storage.from('audio_files').upload(fileName, audioFile);
      final downloadUrl =
          supabase.storage.from('audio_files').getPublicUrl(fileName);
      state = {...state, 'audioUrl': downloadUrl};
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload audio: ${e.toString()}");
    }
  }
}

// Provider for managing all settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, dynamic>>((ref) {
  return SettingsNotifier();
});
