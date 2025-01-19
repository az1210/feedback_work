import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

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

  Future<void> fetchAllFeedbacks({required String userId}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final feedbacksSnapshot = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .where('projectOwnerId', isEqualTo: userId)
          .get();

      final feedbacks = feedbacksSnapshot.docs
          .map((f) => FeedbackModel.fromMap(f.data()))
          .toList();
      state = state.copyWith(data: feedbacks, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> createFeedbackRequest(
      {required FeedbackModel feedback, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      const uuid = Uuid();
      final feedbackId = uuid.v1();
      final fb = feedback.copyWith(id: feedbackId);

      Log.info(fb.requestFeedback?.toMap().toString() ?? '');

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

      if (feedback.requestFeedback != null) {
        for (var i in feedback.requestFeedback!.providers!) {
          await firestore
              .collection(FirebaseConstants.userCollection)
              .doc(i.id)
              .collection(FirebaseConstants.feedbackCollection)
              .doc(feedbackId)
              .set({'id': feedbackId});
        }
      }

      if (feedback.requestFeedback?.groupId != null) {
        await firestore
            .collection(FirebaseConstants.groupCollection)
            .doc(feedback.requestFeedback!.groupId)
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedbackId)
            .set({'id': feedbackId});
      }
      fetchAllFeedbacks(userId: feedback.projectOwnerId!);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> provideFeedback(
      {required FeedbackModel feedback, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      state = state.copyWith(state: AsyncState.loading);
      Log.info(feedback.provideFeedback?.toMap().toString() ?? '');
      final doc = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedback.id)
          .get();
      if (doc.exists) {
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update(feedback.toMap());
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacks(userId: feedback.projectOwnerId!);
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
