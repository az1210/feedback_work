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

  Future<void> createFeedback(
      {required FeedbackModel feedback, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      const uuid = Uuid();
      final feedbackId = uuid.v1();
      final fb = feedback.copyWith(id: feedbackId);
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

      for (var i in feedback.providers) {
        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(i.id)
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedbackId)
            .set({'id': feedbackId});
      }
      if (feedback.groupId != null) {
        await firestore
            .collection(FirebaseConstants.groupCollection)
            .doc(feedback.groupId)
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
