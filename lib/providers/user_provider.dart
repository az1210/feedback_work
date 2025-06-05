import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/supabase_providers.dart';

final userProvider =
    NotifierProvider<UserNotifier, UserNotifierState>(UserNotifier.new);

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

class UserNotifier extends Notifier<UserNotifierState> {
  @override
  UserNotifierState build() {
    Future.microtask(() async {
      final user = await currentUser();
      if (user?.id != null) {
        ref.read(currentUserProvider.notifier).state = user;
      }
    });
    return UserNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllUsers() async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);

    try {
      final response =
          await supabase.from('users').select().order('first_name');

      final users =
          (response as List).map((data) => UserModel.fromMap(data)).toList();

      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchUsersByExpertise({required String expertise}) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);

    try {
      final response =
          await supabase.from('users').select().eq('expertise', expertise);

      final users =
          (response as List).map((data) => UserModel.fromMap(data)).toList();

      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
    }
  }

  Future<UserModel?> currentUser() async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final user = supabase.auth.currentUser;

      if (user == null) {
        Log.error("No logged in user.");
        return null;
      }

      final response =
          await supabase.from('users').select().eq('id', user.id).single();

      if (response == null) {
        Log.error("No user data found for uid: ${user.id}");
        return null;
      }

      return UserModel.fromMap(response);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }

  Future<void> updateProfile({
    required String uid,
    required UserModel userModel,
    void Function()? callback,
  }) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.from('users').update({
        'first_name': userModel.firstName,
        'last_name': userModel.lastName,
        'phone_number': userModel.phoneNumber,
        'username': userModel.username,
        'title': userModel.title,
        'expertise': userModel.expertise,
        'account_type': userModel.accountType,
        'minimum_rate': userModel.minimumRate,
      }).eq('id', uid);

      // Fetch updated user data
      final updatedUser = await fetchUserById(uid: uid);
      if (updatedUser != null) {
        ref.read(currentUserProvider.notifier).state = updatedUser;
      }

      callback?.call();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<UserModel?> fetchUserById({required String uid}) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      final response =
          await supabase.from('users').select().eq('id', uid).single();

      if (response != null) {
        return UserModel.fromMap(response);
      }
      return null;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }
}

class UserNotifierState {
  final String? error;
  final List<UserModel>? data;
  final AsyncState state;

  UserNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  UserNotifierState copyWith({
    String? error,
    List<UserModel>? data,
    AsyncState? state,
  }) {
    return UserNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
