import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final requestFeedbackStepProvider = StateProvider<int>((ref) => 1);
final provideFeedbackStepProvider = StateProvider<int>((ref) => 1);

final feedbackProvider =
    NotifierProvider<FeedbackNotifier, FeedbackNotifierState>(
        FeedbackNotifier.new);

class FeedbackNotifier extends Notifier<FeedbackNotifierState> {
  @override
  FeedbackNotifierState build() {
    return FeedbackNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllOwnFeedbacks({required String userId}) async {
    Log.info("Fetch all own feedback called");
    Log.info("User ID: $userId");

    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      final feedbacksSnapshot = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .where('projectOwnerId', isEqualTo: userId)
          .get();

      final feedbacks = feedbacksSnapshot.docs.map((f) {
        return FeedbackModel.fromMap(f.data());
      }).toList();
      Log.info(
          feedbacks.map((f) => f.ownerSideStatus!.status).toList().toString());
      state = state.copyWith(data: feedbacks, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<List<FeedbackModel>> fetchAllFeedbacksAsProvider(
      {required String userId}) async {
    Log.info("Fetch all another feedback called");
    Log.info("User ID: $userId");

    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final feedbacksSnapshot = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .where('requestFeedback.provider', isEqualTo: userId)
          .get();

      state = state.copyWith(state: AsyncState.success);
      return feedbacksSnapshot.docs.map((f) {
        Log.info(f.data().toString());
        return FeedbackModel.fromMap(f.data());
      }).toList();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(error: e.toString(), state: AsyncState.failure);
      return [];
    }
  }

  Future<void> createFeedbackRequest(
      {required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      const uuid = Uuid();
      final feedbackId = uuid.v1();
      final fb = feedback.copyWith(
        id: feedbackId,
        ownerSideStatus: Status(
          status: FeedbackStatus.requested.name.toTitleCase(),
          modifiedAt: DateTime.now().toString(),
        ),
        providerSideStatus: Status(
          status: FeedbackStatus.requested.name.toTitleCase(),
          modifiedAt: DateTime.now().toString(),
        ),
      );

      Log.info(fb.requestFeedback!.toMap().toString());

      await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .set(fb.toMap());

      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(feedback.projectOwnerId)
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .set({'id': feedbackId});

      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(fb.requestFeedback!.provider)
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .set({'id': feedbackId});

      if (feedback.requestFeedback?.groupId != '') {
        await firestore
            .collection(FirebaseConstants.groupCollection)
            .doc(feedback.requestFeedback!.groupId)
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedbackId)
            .set({'id': feedbackId});
      }
      fetchAllFeedbacksAsProvider(userId: userId);
      fetchAllOwnFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> provideFeedback(
      {required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      state = state.copyWith(state: AsyncState.loading);
      Log.info(feedback.provideFeedback?.toMap().toString() ?? '');
      debugPrint(feedback.provideFeedback?.toMap().toString() ?? '');

      final doc = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedback.id)
          .get();
      if (doc.exists) {
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({
          "ownerSideStatus": feedback.ownerSideStatus!
              .copyWith(
                status: FeedbackStatus.received.name.toTitleCase(),
                modifiedAt: DateTime.now().toString(),
              )
              .toMap()
        });
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({"provideFeedback": feedback.provideFeedback!.toMap()});
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacksAsProvider(userId: userId);
      fetchAllOwnFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> appliedFeedback(
      {required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      state = state.copyWith(state: AsyncState.loading);
      Log.info(feedback.provideFeedback?.toMap().toString() ?? '');
      debugPrint(feedback.provideFeedback?.toMap().toString() ?? '');

      final doc = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedback.id)
          .get();
      if (doc.exists) {
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({
          "ownerSideStatus": feedback.ownerSideStatus!
              .copyWith(
                status: FeedbackStatus.applied.name.toTitleCase(),
                modifiedAt: DateTime.now().toString(),
              )
              .toMap()
        });
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({
          "providerSideStatus": feedback.providerSideStatus!
              .copyWith(
                status: FeedbackStatus.provided.name.toTitleCase(),
                modifiedAt: DateTime.now().toString(),
              )
              .toMap()
        });
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({"appliedFeedback": feedback.appliedFeedback!.toMap()});
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacksAsProvider(userId: userId);
      fetchAllOwnFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> declineFeedback(
      {required EcfModel ecf,
      required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      state = state.copyWith(state: AsyncState.loading);

      final doc = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedback.id)
          .get();
      if (doc.exists) {
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .collection(FirebaseConstants.ecfCollection)
            .add(ecf.toMap());
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({
          "providerSideStatus": feedback.providerSideStatus!
              .copyWith(
                status: FeedbackStatus.requested.name.toTitleCase(),
                modifiedAt: DateTime.now().toString(),
              )
              .toMap()
        });
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacksAsProvider(userId: userId);
      fetchAllOwnFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> deleteCollection(String collectionPath) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);

    try {
      // Fetch the documents in the collection
      final querySnapshot = await collectionRef.get();

      // Delete each document in the collection
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      print("Collection '$collectionPath' deleted successfully.");
    } catch (e) {
      print("Error deleting collection '$collectionPath': $e");
    }
  }

  Future<void> deleteSubCollection({
    required String collectionPath,
    required String docId,
    required String subCollectionPath,
  }) async {
    final collectionRef = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(docId)
        .collection(subCollectionPath);

    try {
      // Fetch the documents in the collection
      final querySnapshot = await collectionRef.get();

      // Delete each document in the collection
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      print("Collection '$collectionPath' deleted successfully.");
    } catch (e) {
      print("Error deleting collection '$collectionPath': $e");
    }
  }
}

class FeedbackNotifierState {
  final String? error;
  final List<FeedbackModel>? data;
  final AsyncState state;

  FeedbackNotifierState({
    this.error,
    this.data,
    required this.state,
  });

  FeedbackNotifierState copyWith({
    String? error,
    List<FeedbackModel>? data,
    AsyncState? state,
  }) {
    return FeedbackNotifierState(
      error: error ?? this.error,
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }
}
