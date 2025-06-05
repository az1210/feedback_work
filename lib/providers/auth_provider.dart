import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/supabase_providers.dart';

final authStateProvider = StateProvider<bool>((ref) => false);

final authServiceProvider =
    NotifierProvider<AuthNotifier, AuthNotifierState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthNotifierState> {
  @override
  AuthNotifierState build() {
    return AuthNotifierState(state: AsyncState.initial);
  }

  Future<void> signUp({
    required UserModel userModel,
    required String password,
    void Function()? callback,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);

    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: userModel.email!,
        password: password,
        data: {
          'first_name': userModel.firstName,
          'last_name': userModel.lastName,
          'phone_number': userModel.phoneNumber,
        },
      );

      if (response.user != null) {
        // Create user profile in the database
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': userModel.email,
          'first_name': userModel.firstName,
          'last_name': userModel.lastName,
          'phone_number': userModel.phoneNumber,
          'minimum_rate': 10.0, // Default value as in original code
        });

        callback?.call();
      }

      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithEmailOrUsername({
    required String emailOrUsername,
    required String password,
    void Function()? callback,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);
    String email = emailOrUsername;

    try {
      if (!emailOrUsername.contains('@')) {
        // If username is provided, get the email from users table
        final response = await supabase
            .from('users')
            .select('email')
            .eq('username', emailOrUsername)
            .single();

        if (response == null) {
          throw Exception('No user found with that username.');
        }
        email = response['email'] as String;
      }

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        ref.read(authStateProvider.notifier).state = true;
        callback?.call();
      }

      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle({void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);

    try {
      final response = await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (response) {
        // Get the user data after successful sign in
        final user = supabase.auth.currentUser;
        if (user != null) {
          // Check if user exists in our users table
          final existingUser =
              await supabase.from('users').select().eq('id', user.id).single();

          if (existingUser == null) {
            // Create new user profile
            await supabase.from('users').insert({
              'id': user.id,
              'email': user.email,
              'first_name': user.userMetadata?['given_name'] ?? '',
              'last_name': user.userMetadata?['family_name'] ?? '',
              'avatar_url': user.userMetadata?['avatar_url'],
              'minimum_rate': 10.0,
            });
          }

          ref.read(authStateProvider.notifier).state = true;
          callback?.call();
        }
      }

      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> completeUserProfile({
    required String uid,
    required UserModel userModel,
  }) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.from('users').update({
        'username': userModel.username,
        'title': userModel.title,
        'expertise': userModel.expertise,
        'account_type': userModel.accountType,
        'minimum_rate': userModel.minimumRate,
      }).eq('id', uid);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      final response = await supabase
          .from('users')
          .select('username')
          .eq('username', username)
          .single();

      return response == null;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return false;
    }
  }

  Future<void> logout() async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.auth.signOut();
      ref.read(authStateProvider.notifier).state = false;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class AuthNotifierState {
  final String? error;
  final AsyncState state;

  AuthNotifierState({
    this.error,
    required this.state,
  });

  AuthNotifierState copyWith({
    String? error,
    AsyncState? state,
  }) {
    return AuthNotifierState(
      error: error ?? this.error,
      state: state ?? this.state,
    );
  }
}
