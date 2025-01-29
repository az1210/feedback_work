import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/network_request_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkProvider = NotifierProvider<NetworkNotifier, NetworkNotifierState>(
    NetworkNotifier.new);

class NetworkNotifier extends Notifier<NetworkNotifierState> {
  @override
  NetworkNotifierState build() {
    return NetworkNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllOwnNetwork() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    UserModel currentUser = ref.watch(currentUserProvider.notifier).state!;
    try {
      final networksSnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(currentUser.id)
          .collection(FirebaseConstants.networkCollection)
          .get();

      List<String> userIds = networksSnapshot.docs
          .map((doc) => doc.data()['id'] as String)
          .toList();
      List<UserModel> users = [];
      for (var i in userIds) {
        final doc = await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(i)
            .get();
        if (doc.exists) {
          users.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
        }
      }

      state = state.copyWith(data: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchAllRequests() async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    UserModel currentUser = ref.watch(currentUserProvider.notifier).state!;
    try {
      final networksSnapshot = await firestore
          .collection(FirebaseConstants.networkCollection)
          .where('requestedTo', isEqualTo: currentUser.id)
          .get();

      Log.info(
          "Request from====> ${networksSnapshot.docs.map((c) => c.data()['requestedFrom'].toString()).toList().toString()}");

      final List<String> ids = networksSnapshot.docs
          .map((c) => c.data()['requestedFrom'] as String)
          .toList();
      List<UserModel> users = [];
      for (var i in ids) {
        final doc = await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(i)
            .get();
        if (doc.exists) {
          Log.info(doc.data().toString());
          users.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
        }
      }

      state = state.copyWith(requests: users, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> requestNetwork(
      {required NetworkRequestModel networkRequestModel,
      void Function()? callback}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      Log.info("request network");
      Log.info(networkRequestModel.toMap().toString());
      state = state.copyWith(state: AsyncState.loading);
      final n = networkRequestModel.copyWith(
          connectionStatus: ConnectionStatus.requested.name.toString());
      Log.info(n.toMap().toString());
      await firestore
          .collection(FirebaseConstants.networkCollection)
          .doc(
              "${networkRequestModel.requestedFrom}${networkRequestModel.requestedTo}")
          .set(n.toMap());
      state = state.copyWith(state: AsyncState.success);
      callback?.call();
      fetchAllRequests();
      fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> requestAccept(
      {required String currentUserId, required String connectionId}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(currentUserId)
          .collection(FirebaseConstants.networkCollection)
          .doc("$connectionId$currentUserId")
          .set({'id': connectionId});
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(connectionId)
          .collection(FirebaseConstants.networkCollection)
          .doc("$connectionId$currentUserId")
          .set({'id': currentUserId});
      await firestore
          .collection(FirebaseConstants.networkCollection)
          .doc("$connectionId$currentUserId")
          .delete();
      state = state.copyWith(state: AsyncState.success);

      fetchAllRequests();
      fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> requestDecline({
    required String currentUserId,
    required String connectionId,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final snapshots = await firestore
          .collection(FirebaseConstants.networkCollection)
          .where(
            'requestedTo',
            isEqualTo: connectionId,
          )
          .where('requestedFrom', isEqualTo: currentUserId)
          .get();
      for (var i in snapshots.docs) {
        await firestore
            .collection(FirebaseConstants.networkCollection)
            .doc(i.id)
            .delete();
      }
      state = state.copyWith(state: AsyncState.success);

      fetchAllRequests();
      fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> disconnect({
    required String userId,
    required String connectionUserId,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final userSnapshots = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.networkCollection)
          .where("id", isEqualTo: connectionUserId)
          .get();
      for (var d in userSnapshots.docs) {
        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(userId)
            .collection(FirebaseConstants.networkCollection)
            .doc(d.id)
            .delete();
      }

      final snapshots = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(connectionUserId)
          .collection(FirebaseConstants.networkCollection)
          .where("id", isEqualTo: userId)
          .get();
      for (var d in snapshots.docs) {
        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(connectionUserId)
            .collection(FirebaseConstants.networkCollection)
            .doc(d.id)
            .delete();
      }
      state = state.copyWith(state: AsyncState.success);
      fetchAllRequests();
      fetchAllOwnNetwork();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
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
