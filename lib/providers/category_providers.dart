import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryNotifierState>(
        CategoryNotifier.new);

class CategoryNotifier extends Notifier<CategoryNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  CategoryNotifierState build() {
    return CategoryNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllCategories() async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      Log.info('Fetching categories from Supabase...');

      final response =
          await supabase.from('categories').select().order('category_title');

      Log.info('Categories response raw: $response');

      if (response == null) {
        Log.error('Null response from categories query');
        state = state.copyWith(
            state: AsyncState.failure, error: 'Failed to fetch categories');
        return;
      }

      final categories = (response as List).map((c) {
        Log.info('Processing category: $c');
        return CategoryModel.fromMap(c);
      }).toList();

      Log.info('Parsed ${categories.length} categories successfully');
      state = state.copyWith(data: categories, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error('Error fetching categories: ${e.toString()}');
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> createCategory({required CategoryModel categoryModel}) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      await supabase.from('categories').insert(categoryModel.toMap());
      await fetchAllCategories();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
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
