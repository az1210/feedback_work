import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedback_work/core/utils/utils.dart';

final userServiceProvider =
    NotifierProvider<UserNotifier, UserNotifierState>(UserNotifier.new);

class UserNotifier extends Notifier<UserNotifierState> {
  @override
  UserNotifierState build() {
    return UserNotifierState(state: AsyncState.initial);
  }

  // Sign up
  Future<void> fetchAllUsers() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final usersSnapshot =
          await firestore.collection(FirebaseConstants.userCollection).get();

      final users =
          usersSnapshot.docs.map((u) => UserModel.fromMap(u.data())).toList();
      Log.info(users.map((u) => u.email).toList().toString());
      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
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
