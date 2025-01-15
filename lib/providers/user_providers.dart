import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedback_work/core/utils/utils.dart';

final userProvider =
    NotifierProvider<UserNotifier, UserNotifierState>(UserNotifier.new);

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

class UserNotifier extends Notifier<UserNotifierState> {
  @override
  UserNotifierState build() {
    Future.microtask(() async {
      ref.read(currentUserProvider.notifier).state = await currentUser();
    });
    return UserNotifierState(state: AsyncState.initial);
  }

  // Sign up
  Future<void> fetchAllUsers() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      // final usersDoc =
      //     firestore.collection(FirebaseConstants.userCollection).doc();

      // await firestore
      //     .collection(FirebaseConstants.userCollection)
      //     .doc(usersDoc.id)
      //     .update({"id": usersDoc.id, "minimumRate": 10});

      // final usersCollection = FirebaseFirestore.instance.collection('users');

      // final querySnapshot = await usersCollection.get();

      // for (final doc in querySnapshot.docs) {
      //   await usersCollection.doc(doc.id).update({
      //     'id': doc.id,
      //     "minimumRate": 10.0,
      //   });
      // }

      final usersSnapshot =
          await firestore.collection(FirebaseConstants.userCollection).get();
      final users =
          usersSnapshot.docs.map((u) => UserModel.fromMap(u.data())).toList();
      Log.info(users.map((u) => u.id).toList().toString());
      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchUsersByExpertise({required String expertise}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollection)
          .where('expertise', isEqualTo: expertise)
          .get();

      // Map each document to a list of user data
      List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<UserModel> currentUser() async {
    try {
      final firestore = ref.read(firestoreProvider);
      final auth = ref.read(firebaseAuthProvider);
      state = state.copyWith(state: AsyncState.loading);
      final querySnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(auth.currentUser?.uid)
          .get();

      // Map each document to a list of user data
      return UserModel.fromMap(querySnapshot.data() as Map<String, dynamic>);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return UserModel();
    }
  }

  Future<void> updateProfile({
    required String uid,
    required UserModel userModel,
    void Function()? callback,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(uid)
          .update(
        {
          'firstName': userModel.firstName,
          'lastName': userModel.lastName,
          'phoneNumber': userModel.phoneNumber,
          "username": userModel.username,
          "title": userModel.title,
          "expertise": userModel.expertise,
          "accountType": userModel.accountType,
          "minimumRate": userModel.minimumRate,
        },
      ).then((_) =>
              ref.read(fetchUserByIdProvider.notifier).fetchUser(uid: uid));
      callback?.call();
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

final fetchUserByIdProvider =
    NotifierProvider<FetchUserByIdNotifier, FetchUserByIdState>(
        FetchUserByIdNotifier.new);

class FetchUserByIdNotifier extends Notifier<FetchUserByIdState> {
  @override
  FetchUserByIdState build() {
    return FetchUserByIdState(state: AsyncState.initial);
  }

  Future<void> fetchUser({required String uid}) async {
    try {
      final firestore = ref.read(firestoreProvider);
      state = state.copyWith(state: AsyncState.loading);
      final querySnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(uid)
          .get();

      // Map each document to a list of user data
      final user =
          UserModel.fromMap(querySnapshot.data() as Map<String, dynamic>);
      state = state.copyWith(data: user, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class FetchUserByIdState {
  final String? error;
  final UserModel? data;
  final AsyncState state;

  FetchUserByIdState({
    this.error,
    this.data,
    required this.state,
  });

  FetchUserByIdState copyWith({
    String? error,
    UserModel? data,
    AsyncState? state,
  }) {
    return FetchUserByIdState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
