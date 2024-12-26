import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  SettingsNotifier()
      : super({
          'startTime': DateTime.now(),
          'endTime': DateTime.now().add(const Duration(minutes: 2)),
          'breakTime': const Duration(minutes: 1),
          'travelPerHour': 50.0,
          'travelPerMinute': 0.833,
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
    };
  }
}

// Provider for managing all settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, dynamic>>((ref) {
  return SettingsNotifier();
});
