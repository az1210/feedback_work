import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestFeedbackStepProvider = StateProvider<int>((ref) => 1);

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryNotifierState>(
        CategoryNotifier.new);

class CategoryNotifier extends Notifier<CategoryNotifierState> {
  @override
  CategoryNotifierState build() {
    return CategoryNotifierState(state: AsyncState.initial);
  }

  Future<List<String?>> fetchAllExpertise() async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollection)
          .get();

      // Log.info(querySnapshot.docs.first.get("accountType"));
      List<String?> allExpertise = querySnapshot.docs
          .map((doc) => doc.get('expertise') as String?)
          .toList();

      state = state.copyWith(data: allExpertise, state: AsyncState.success);
      return allExpertise;
    } catch (e) {
      Log.error('Error fetching expertise records: $e');
      return [];
    }
  }

  Future<void> fetchAllCategories() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final categoriesSnapshot = await firestore
          .collection(FirebaseConstants.categoryCollection)
          .get();

      final categories = categoriesSnapshot.docs
          .map((c) => c.data()["expertise"] as String)
          .toList();
      state = state.copyWith(data: categories, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class CategoryNotifierState {
  final String? error;
  final List<String?>? data;
  final AsyncState state;

  CategoryNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  CategoryNotifierState copyWith({
    String? error,
    List<String?>? data,
    AsyncState? state,
  }) {
    return CategoryNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
