import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/models/child_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedback_work/core/utils/utils.dart';

final childProvider =
    NotifierProvider<ChildNotifier, ChildNotifierState>(ChildNotifier.new);

class ChildNotifier extends Notifier<ChildNotifierState> {
  @override
  ChildNotifierState build() {
    return ChildNotifierState(state: AsyncState.initial);
  }

  // Create Child account
  Future<void> createChildAccount({
    required ChildModel childModel,
    required String password,
    required String parentId,
    void Function()? callBack,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: childModel.email!,
        password: password,
      );

      // Save child info into parent
      ChildModel model = ChildModel(
        firstName: childModel.firstName,
        lastName: childModel.lastName,
        email: childModel.email,
        avaterUrl: childModel.avaterUrl,
      );
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(parentId)
          .collection(FirebaseConstants.childCollection)
          .doc(userCredential.user!.uid)
          .set(model.toMap())
          .then((_) {
        fetchAllChilds(parentId: parentId);
      });

      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Sign up
  Future<void> fetchAllChilds({required String parentId}) async {
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

      final childSnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(parentId)
          .collection(FirebaseConstants.childCollection)
          .get();
      final child =
          childSnapshot.docs.map((u) => ChildModel.fromMap(u.data())).toList();
      state = state.copyWith(data: child, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
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
