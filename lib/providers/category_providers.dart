import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/category_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryNotifierState>(
        CategoryNotifier.new);

class CategoryNotifier extends Notifier<CategoryNotifierState> {
  @override
  CategoryNotifierState build() {
    return CategoryNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllCategories() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final categoriesSnapshot = await firestore
          .collection(FirebaseConstants.categoryCollection)
          .orderBy("categoryTitle")
          .get();

      final categories = categoriesSnapshot.docs
          .map((c) => CategoryModel.fromMap(c.data()))
          .toList();
      state = state.copyWith(data: categories, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> createCategory({required CategoryModel categoryModel}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      await firestore
          .collection(FirebaseConstants.categoryCollection)
          .doc(categoryModel.categoryTitle)
          .set(categoryModel.toMap())
          .then((_) {
        fetchAllCategories();
      });
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class CategoryNotifierState {
  final String? error;
  final List<CategoryModel>? data;
  final AsyncState state;

  CategoryNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  CategoryNotifierState copyWith({
    String? error,
    List<CategoryModel>? data,
    AsyncState? state,
  }) {
    return CategoryNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
