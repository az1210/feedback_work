import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final groupProvider =
    NotifierProvider<GroupNotifier, GroupNotifierState>(GroupNotifier.new);
final joinGroupProvider =
    NotifierProvider<JoinGroupNotifier, JoinGroupState>(JoinGroupNotifier.new);

class GroupNotifier extends Notifier<GroupNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  GroupNotifierState build() {
    return GroupNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllGroups() async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      final response = await supabase.from('groups').select().order('name');

      final groups =
          (response as List).map((data) => GroupModel.fromMap(data)).toList();
      state = state.copyWith(data: groups, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> createGroup(
      {required GroupModel group, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      final response =
          await supabase.from('groups').insert(group.toMap()).select().single();

      if (response != null) {
        await fetchAllGroups();
        callback?.call();
        state = state.copyWith(state: AsyncState.success);
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }
}

class JoinGroupNotifier extends Notifier<JoinGroupState> {
  final supabase = Supabase.instance.client;

  @override
  JoinGroupState build() {
    return JoinGroupState(state: AsyncState.initial);
  }

  Future<void> joinGroup({
    required String groupId,
    required String userId,
    void Function()? callback,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      // First check if group exists
      final group =
          await supabase.from('groups').select().eq('id', groupId).single();

      if (group != null) {
        // Add user to group_members table
        await supabase.from('group_members').insert({
          'group_id': groupId,
          'user_id': userId,
        });

        callback?.call();
        state = state.copyWith(state: AsyncState.success);
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }
}

class GroupNotifierState {
  final String? error;
  final List<GroupModel>? data;
  final AsyncState state;

  GroupNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  GroupNotifierState copyWith({
    String? error,
    List<GroupModel>? data,
    AsyncState? state,
  }) {
    return GroupNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}

class JoinGroupState {
  final String? error;
  final AsyncState state;

  JoinGroupState({
    this.error,
    required this.state,
  });

  JoinGroupState copyWith({
    String? error,
    AsyncState? state,
  }) {
    return JoinGroupState(
      error: error ?? this.error,
      state: state ?? this.state,
    );
  }
}
