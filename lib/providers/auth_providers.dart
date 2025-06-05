import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedback_work/utility/custom_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/supabase_providers.dart';

final authProvider = StateProvider<bool>((ref) => false);

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
    void Function()? callBack,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);

    try {
      // Clean and validate the email
      final email = userModel.email?.trim().toLowerCase();
      if (email == null || email.isEmpty) {
        throw Exception('Email is required');
      }

      // First create the auth user with minimal data
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': userModel.firstName?.trim(),
          'last_name': userModel.lastName?.trim(),
          'phone_number': userModel.phoneNumber?.trim(),
        },
      );

      if (response.user != null) {
        try {
          // Create the user profile
          await supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'first_name': userModel.firstName?.trim(),
            'last_name': userModel.lastName?.trim(),
            'phone_number': userModel.phoneNumber?.trim(),
            'minimum_rate': 10.0,
          });

          // Update currentUserProvider
          ref.read(currentUserProvider.notifier).state =
              userModel.copyWith(id: response.user!.id);

          // Update auth state
          ref.read(authProvider.notifier).state = true;

          // Call the callback after everything is successful
          callBack?.call();
          state = state.copyWith(state: AsyncState.success);
        } catch (e) {
          Log.error('Error creating user profile: ${e.toString()}');
          throw e;
        }
      } else {
        throw Exception('Failed to create user account');
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure);

      String errorMessage;
      if (e is AuthApiException) {
        if (e.message.contains('email_address_not_authorized')) {
          errorMessage =
              'Please set up a custom SMTP provider to send emails to this address';
        } else if (e.message.contains('User already registered')) {
          errorMessage = 'This email is already registered';
        } else {
          errorMessage = e.message;
        }
      } else {
        errorMessage = 'Failed to sign up';
      }

      throw Exception(errorMessage);
    }
  }

  Future<bool> isUserSignedIn() async {
    final supabase = ref.read(supabaseClientProvider);
    final session = supabase.auth.currentSession;
    return session != null;
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
      // Check if input is a username, not an email
      if (!emailOrUsername.contains('@')) {
        final response = await supabase
            .from('users')
            .select()
            .eq('username', emailOrUsername)
            .single();

        if (response == null) {
          throw Exception('No user found with that username.');
        }
        email = response['email'];
      }

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        ref.read(authProvider.notifier).state = true;
        callback?.call();
      }
      state = state.copyWith(state: AsyncState.success);
    } catch (e) {
      Log.error(e.toString());
      state = state.copyWith(state: AsyncState.failure);
      showToast(message: "Failed to sign in: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.signOut();
    ref.read(authProvider.notifier).state = false;
    ref.read(currentUserProvider.notifier).state = null;
  }

  Future<bool> isUsernameAvailable(String username) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('username', username)
          .maybeSingle();
      return response == null;
    } catch (e) {
      Log.error(e.toString());
      return false;
    }
  }

  Future<void> completeUserProfile({
    required String uid,
    required UserModel userModel,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.from('users').update({
        'username': userModel.username,
        'title': userModel.title,
        'expertise': userModel.expertise,
        'account_type': userModel.accountType,
        'minimum_rate': userModel.minimumRate,
      }).eq('id', uid);
      state = state.copyWith(state: AsyncState.success);
    } catch (e) {
      Log.error(e.toString());
      state = state.copyWith(state: AsyncState.failure);
      throw Exception('Failed to complete profile: ${e.toString()}');
    }
  }

  Future<void> signInWithGoogle({void Function()? callBack}) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final response = await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://vribqwdjfgonhhyngjtv.supabase.co/auth/v1/callback',
        queryParams: {
          'access_type': 'offline',
          'prompt': 'consent',
        },
      );

      // After successful OAuth sign-in, get the session
      final session = supabase.auth.currentSession;
      if (session != null) {
        final userResponse = await supabase.auth.getUser();
        if (userResponse.user != null) {
          final userData = await supabase
              .from('users')
              .select()
              .eq('id', userResponse.user!.id)
              .single();

          if (userData != null) {
            final user = UserModel.fromMap(userData);
            ref.read(currentUserProvider.notifier).state = user;
            ref.read(authProvider.notifier).state = true;
          }
        }
        state = state.copyWith(state: AsyncState.success);
        callBack?.call();
      } else {
        state = state.copyWith(
          state: AsyncState.failure,
          error: 'Google sign in failed',
        );
      }
    } catch (e) {
      Log.error(e.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }

  Future<void> signInWithFacebook({void Function()? callBack}) async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final response = await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'https://vribqwdjfgonhhyngjtv.supabase.co/auth/v1/callback',
        queryParams: {
          'auth_type': 'rerequest',
          'scope': 'email,public_profile',
        },
      );

      // After successful OAuth sign-in, get the session
      final session = supabase.auth.currentSession;
      if (session != null) {
        final userResponse = await supabase.auth.getUser();
        if (userResponse.user != null) {
          final userData = await supabase
              .from('users')
              .select()
              .eq('id', userResponse.user!.id)
              .single();

          if (userData != null) {
            final user = UserModel.fromMap(userData);
            ref.read(currentUserProvider.notifier).state = user;
            ref.read(authProvider.notifier).state = true;
          }
        }
        state = state.copyWith(state: AsyncState.success);
        callBack?.call();
      } else {
        state = state.copyWith(
          state: AsyncState.failure,
          error: 'Facebook sign in failed',
        );
      }
    } catch (e) {
      Log.error(e.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
      );
      throw Exception('Facebook sign in failed: ${e.toString()}');
    }
  }
}

class AuthNotifierState {
  final AsyncState state;
  final String? error;

  AuthNotifierState({
    required this.state,
    this.error,
  });

  AuthNotifierState copyWith({
    AsyncState? state,
    String? error,
  }) {
    return AuthNotifierState(
      state: state ?? this.state,
      error: error ?? this.error,
    );
  }
}

final keepMeSignedInProvider =
    StateNotifierProvider<CheckboxStateNotifier, bool>(
  (ref) => CheckboxStateNotifier(),
);

class CheckboxStateNotifier extends StateNotifier<bool> {
  CheckboxStateNotifier() : super(false);

  void toggle(bool value) {
    state = value; // Update the state
  }
}

Future<bool> isLoggedIn(Ref ref) async {
  return ref.read(authProvider);
}
