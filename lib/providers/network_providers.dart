import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/network_request_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final networkProvider = NotifierProvider<NetworkNotifier, NetworkNotifierState>(
    NetworkNotifier.new);

class NetworkNotifier extends Notifier<NetworkNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  NetworkNotifierState build() {
    return NetworkNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllOwnNetwork() async {
    state = state.copyWith(state: AsyncState.loading);
    UserModel? currentUser = ref.watch(currentUserProvider);
    try {
      if (currentUser?.id == null) {
        throw Exception('No user logged in');
      }

      final userId = currentUser!.id as String;
      final response = await supabase
          .from('networks')
          .select('connected_user_id')
          .eq('user_id', userId);

      List<String> userIds = (response as List)
          .map((doc) => doc['connected_user_id'] as String)
          .toList();

      List<UserModel> users = [];
      for (var id in userIds) {
        final userResponse =
            await supabase.from('users').select().eq('id', id).single();
        if (userResponse != null) {
          users.add(UserModel.fromMap(userResponse));
        }
      }

      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchAllRequests() async {
    state = state.copyWith(state: AsyncState.loading);
    UserModel? currentUser = ref.watch(currentUserProvider);
    try {
      if (currentUser?.id == null) {
        throw Exception('No user logged in');
      }

      final userId = currentUser!.id as String;
      final response = await supabase
          .from('network_requests')
          .select()
          .eq('requested_to', userId);

      final List<String> requestedFromIds = (response as List)
          .map((doc) => doc['requested_from'] as String)
          .toList();

      List<UserModel> users = [];
      for (var id in requestedFromIds) {
        final userResponse =
            await supabase.from('users').select().eq('id', id).single();
        if (userResponse != null) {
          users.add(UserModel.fromMap(userResponse));
        }
      }

      state = state.copyWith(requests: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> requestNetwork({
    required NetworkRequestModel networkRequestModel,
    void Function()? callback,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      await supabase.from('network_requests').insert({
        'requested_from': networkRequestModel.requestedFrom,
        'requested_to': networkRequestModel.requestedTo,
        'status': ConnectionStatus.requested.name,
      });

      state = state.copyWith(state: AsyncState.success);
      callback?.call();
      await fetchAllRequests();
      await fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> requestAccept({
    required String currentUserId,
    required String connectionId,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      try {
        // Create bidirectional connection
        await supabase.from('networks').insert([
          {'user_id': currentUserId, 'connected_user_id': connectionId},
          {'user_id': connectionId, 'connected_user_id': currentUserId},
        ]);

        // Delete the request - improved query to handle UUID comparison
        await supabase
            .from('network_requests')
            .delete()
            .eq('requested_from', connectionId)
            .eq('requested_to', currentUserId);

        state = state.copyWith(state: AsyncState.success);
        await fetchAllRequests();
        await fetchAllOwnNetwork();
      } catch (e) {
        Log.error("Error accepting request: $e");

        // If RLS error, try a single insert at a time
        if (e is PostgrestException && e.code == '42501') {
          // Try inserting one by one
          try {
            await supabase.from('networks').insert(
                {'user_id': currentUserId, 'connected_user_id': connectionId});

            await supabase.from('networks').insert(
                {'user_id': connectionId, 'connected_user_id': currentUserId});

            // Delete the request - improved query to handle UUID comparison
            await supabase
                .from('network_requests')
                .delete()
                .eq('requested_from', connectionId)
                .eq('requested_to', currentUserId);

            state = state.copyWith(state: AsyncState.success);
            await fetchAllRequests();
            await fetchAllOwnNetwork();
            return; // Success, exit early
          } catch (retryError) {
            Log.error("Error in retry: $retryError");
            throw retryError; // Rethrow to be caught by outer catch
          }
        }

        // If not an RLS error or retry failed, rethrow
        throw e;
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> requestDecline({
    required String currentUserId,
    required String connectionId,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Using eq for proper type handling
      await supabase
          .from('network_requests')
          .delete()
          .eq('requested_from', connectionId)
          .eq('requested_to', currentUserId);

      state = state.copyWith(state: AsyncState.success);
      await fetchAllRequests();
      await fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> disconnect({
    required String userId,
    required String connectionUserId,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Remove bidirectional connection - using eq for proper type handling
      await supabase
          .from('networks')
          .delete()
          .eq('user_id', userId)
          .eq('connected_user_id', connectionUserId);

      await supabase
          .from('networks')
          .delete()
          .eq('user_id', connectionUserId)
          .eq('connected_user_id', userId);

      state = state.copyWith(state: AsyncState.success);
      await fetchAllRequests();
      await fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }
}

class NetworkNotifierState {
  final String? error;
  final List<UserModel>? data;
  final List<UserModel>? requests;
  final AsyncState state;

  NetworkNotifierState({
    this.error,
    this.data,
    this.requests,
    required this.state,
  });

  NetworkNotifierState copyWith({
    String? error,
    List<UserModel>? data,
    List<UserModel>? requests,
    AsyncState? state,
  }) {
    return NetworkNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      requests: requests ?? this.requests,
      state: state ?? this.state,
    );
  }
}
