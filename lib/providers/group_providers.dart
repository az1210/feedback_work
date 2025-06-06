import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/models/user_model.dart';
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
      List<GroupModel> groups = [];

      try {
        // First, get all groups
        final response = await supabase.from('groups').select().order('name');

        // Convert to list of groups (without users initially)
        groups = (response as List).map((data) {
          try {
            // Create group with empty users list initially
            return GroupModel(
              id: data['id'] ?? '',
              ownerId: data['owner_id'] ?? '',
              name: data['name'] ?? '',
              description: data['description'],
              isPublic: data['is_public'] ?? false,
              users: [],
            );
          } catch (e) {
            Log.error("Error parsing group data: $e");
            // Return a default group model
            return GroupModel(
              id: data['id'] ?? '',
              ownerId: data['owner_id'] ?? '',
              name: data['name'] ?? '',
              description: data['description'],
              isPublic: data['is_public'] ?? false,
              users: [],
            );
          }
        }).toList();
      } catch (e) {
        // If we can't fetch groups, log the error but continue with empty list
        Log.error("Error fetching groups: $e");
        // Don't rethrow, just use an empty list
      }

      // If we have groups, try to fetch members for each
      if (groups.isNotEmpty) {
        for (int i = 0; i < groups.length; i++) {
          try {
            // Get group members
            final membersResponse = await supabase
                .from('group_members')
                .select('user_id')
                .eq('group_id', groups[i].id ?? '');

            // If there are members, fetch their user details
            if ((membersResponse as List).isNotEmpty) {
              List<String> userIds = membersResponse
                  .map((member) => member['user_id'].toString())
                  .toList();

              List<UserModel> groupUsers = [];
              for (String userId in userIds) {
                try {
                  final userResponse = await supabase
                      .from('users')
                      .select()
                      .eq('id', userId)
                      .single();

                  if (userResponse != null) {
                    groupUsers.add(UserModel.fromMap(userResponse));
                  }
                } catch (e) {
                  // Just log the error and continue
                  Log.error("Error fetching user $userId: $e");
                }
              }

              // Update the group with its users
              groups[i] = groups[i].copyWith(users: groupUsers);
            }
          } catch (e) {
            // Just log the error and continue
            Log.error("Error fetching members for group ${groups[i].id}: $e");
          }
        }
      }

      // Return success even if we had some failures
      state = state.copyWith(data: groups, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
          state: AsyncState.failure,
          error: e.toString(),
          data: [] // Return empty list on failure
          );
    }
  }

  Future<void> createGroup(
      {required GroupModel group, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      // Convert model fields to match database column names
      final groupData = {
        'id': group.id,
        'owner_id': group.ownerId, // Changed from ownerId to owner_id
        'name': group.name,
        'description': group.description,
        'is_public': group.isPublic, // Changed from isPublic to is_public
      };

      final response =
          await supabase.from('groups').insert(groupData).select().single();

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
      try {
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
      } catch (e) {
        Log.error("Error joining group: $e");
        throw e; // Rethrow to be caught by outer try-catch
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
