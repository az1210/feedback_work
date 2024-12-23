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
