import 'package:feedback_work/models/child_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedback_work/core/utils/utils.dart';

final childProvider =
    NotifierProvider<ChildNotifier, ChildNotifierState>(ChildNotifier.new);

class ChildNotifier extends Notifier<ChildNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  ChildNotifierState build() {
    return ChildNotifierState(state: AsyncState.initial);
  }

  Future<void> createChildAccount({
    required ChildModel childModel,
    required String password,
    required String parentId,
    void Function()? callBack,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      final response = await supabase.auth.signUp(
        email: childModel.email,
        password: password,
      );

      if (response.user != null) {
        // Save child info into parent's children collection
        await supabase.from('children').insert({
          'id': response.user!.id,
          'parent_id': parentId,
          'first_name': childModel.firstName,
          'last_name': childModel.lastName,
          'email': childModel.email,
          'avatar_url': childModel.avaterUrl,
        });

        await fetchAllChilds(parentId: parentId);
        callBack?.call();
        state = state.copyWith(state: AsyncState.success);
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchAllChilds({required String parentId}) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      final response =
          await supabase.from('children').select().eq('parent_id', parentId);

      final children =
          (response as List).map((data) => ChildModel.fromMap(data)).toList();
      state = state.copyWith(data: children, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }
}

class ChildNotifierState {
  final String? error;
  final List<ChildModel>? data;
  final AsyncState state;

  ChildNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  ChildNotifierState copyWith({
    String? error,
    List<ChildModel>? data,
    AsyncState? state,
  }) {
    return ChildNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
