import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/parent_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addParentStepProvider = StateProvider<int>((ref) => 1);

final parentProvider =
    NotifierProvider<ParentNotifier, ParentNotifierState>(ParentNotifier.new);

class ParentNotifier extends Notifier<ParentNotifierState> {
  @override
  ParentNotifierState build() {
    return ParentNotifierState(state: AsyncState.initial);
  }

  // Add Parent
  Future<void> addParent({
    required ParentModel parentModel,
    required String childId,
    void Function()? callBack,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      // Save parent info into child
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(childId)
          .collection(FirebaseConstants.parentCollection)
          .doc(parentModel.id)
          .set(parentModel.toMap())
          .then((_) {
        fetchAllParents(childId: childId);
      });

      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchAllParents({required String childId}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final childSnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(childId)
          .collection(FirebaseConstants.parentCollection)
          .get();
      final parent =
          childSnapshot.docs.map((u) => ParentModel.fromMap(u.data())).toList();
      state = state.copyWith(data: parent, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
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
