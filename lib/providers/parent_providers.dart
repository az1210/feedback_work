import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/parent_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final addParentStepProvider = StateProvider<int>((ref) => 1);

final parentProvider =
    NotifierProvider<ParentNotifier, ParentNotifierState>(ParentNotifier.new);

class ParentNotifier extends Notifier<ParentNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  ParentNotifierState build() {
    return ParentNotifierState(state: AsyncState.initial);
  }

  Future<void> addParent({
    required ParentModel parentModel,
    required String childId,
    void Function()? callBack,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      await supabase.from('parents').insert({
        ...parentModel.toMap(),
        'child_id': childId,
      });

      await fetchAllParents(childId: childId);
      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchAllParents({required String childId}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      final response =
          await supabase.from('parents').select().eq('child_id', childId);

      final parents =
          (response as List).map((data) => ParentModel.fromMap(data)).toList();

      state = state.copyWith(data: parents, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }
}

class ParentNotifierState {
  final String? error;
  final List<ParentModel>? data;
  final AsyncState state;

  ParentNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  ParentNotifierState copyWith({
    String? error,
    List<ParentModel>? data,
    AsyncState? state,
  }) {
    return ParentNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
