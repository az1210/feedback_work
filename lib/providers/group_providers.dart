import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/group_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupProvider =
    NotifierProvider<GroupNotifier, GroupNotifierState>(GroupNotifier.new);
final joinGroupProvider =
    NotifierProvider<JoinGroupNotifier, JoinGroupState>(JoinGroupNotifier.new);

class GroupNotifier extends Notifier<GroupNotifierState> {
  @override
  GroupNotifierState build() {
    return GroupNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllGroups() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final groupsSnapshot = await firestore
          .collection(FirebaseConstants.groupCollection)
          .orderBy("name")
          .get();

      final groups =
          groupsSnapshot.docs.map((c) => GroupModel.fromMap(c.data())).toList();
      state = state.copyWith(data: groups, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> createGroup(
      {required GroupModel group, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final docRef = await firestore
          .collection(FirebaseConstants.groupCollection)
          .add(group.toMap());
      await docRef.update({"id": docRef.id}).then((_) {
        fetchAllGroups();
      });
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class JoinGroupNotifier extends Notifier<JoinGroupState> {
  @override
  JoinGroupState build() {
    Future.microtask(() {});
    return JoinGroupState(state: AsyncState.initial);
  }

  Future<void> joinGroup(
      {required String groupId,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final groupsSnapshot = await firestore
          .collection(FirebaseConstants.groupCollection)
          .doc(groupId)
          .get();
      Log.info("Is Exist ++++> ${groupsSnapshot.exists.toString()}");
      final docRef =
          firestore.collection(FirebaseConstants.groupCollection).doc(groupId);
      await docRef.update({
        "uIds": FieldValue.arrayUnion([userId])
      });
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
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
