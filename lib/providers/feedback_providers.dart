import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/project_progress_provider.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';

final requestFeedbackStepProvider = StateProvider<int>((ref) => 1);
final provideFeedbackStepProvider = StateProvider<int>((ref) => 1);

final feedbackProvider =
    NotifierProvider<FeedbackNotifier, FeedbackNotifierState>(
        FeedbackNotifier.new);
final ecfProvider =
    NotifierProvider<ECFNotifier, ECFNotifierState>(ECFNotifier.new);

class FeedbackNotifier extends Notifier<FeedbackNotifierState> {
  @override
  FeedbackNotifierState build() {
    return FeedbackNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllFeedbacks({required String userId}) async {
    Log.info("Fetch all own feedback called");
    Log.info("User ID: $userId");

    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);
      List<FeedbackModel> allFeedbacks = [];
      final feedbacksSnapshot = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .where('ownerId', isEqualTo: userId)
          .get();

      allFeedbacks.addAll(feedbacksSnapshot.docs.map((f) {
        return FeedbackModel.fromMap(f.data());
      }).toList());

      final providerFeedbacksSnapshot = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .where('providerId', isEqualTo: userId)
          .get();
      allFeedbacks.addAll(providerFeedbacksSnapshot.docs.map((f) {
        Log.info(f.data().toString());
        return FeedbackModel.fromMap(f.data());
      }).toList());
      state =
          state.copyWith(allFeedback: allFeedbacks, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Future<void> fetchAllOwnFeedbacks({required String userId}) async {
  //   Log.info("Fetch all own feedback called");
  //   Log.info("User ID: $userId");

  //   FirebaseFirestore firestore = ref.read(firestoreProvider);
  //   try {
  //     state = state.copyWith(state: AsyncState.loading);
  //     final feedbacksSnapshot = await firestore
  //         .collection(FirebaseConstants.feedbackCollection)
  //         .where('ownerId', isEqualTo: userId)
  //         .get();
  //     Log.info(
  //         "Feedback owner id====> ${feedbacksSnapshot.docs.map((f) => f.data()['ownerId'])}");
  //     Log.info(
  //         "Feedback Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['requestFeedback'])}");

  //     Log.info(
  //         "Feedback Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['provideFeedback'])}");
  //     Log.info(
  //         "Feedback Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['ownerSideStatus'])}");
  //     Log.info(
  //         "Feedback Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['providerSideStatus'])}");

  //     final feedbacks = feedbacksSnapshot.docs.map((f) {
  //       return FeedbackModel.fromMap(f.data());
  //     }).toList();
  //     Log.info(
  //         feedbacks.map((f) => f.ownerSideStatus!.status).toList().toString());
  //     state = state.copyWith(
  //         allFeedbackAsOwner: feedbacks, state: AsyncState.success);
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //   }
  // }

  // Future<void> fetchAllFeedbacksAsProvider({required String userId}) async {
  //   Log.info("Fetch all another feedback called");
  //   Log.info("User ID: $userId");

  //   state = state.copyWith(state: AsyncState.loading);
  //   FirebaseFirestore firestore = ref.read(firestoreProvider);
  //   try {
  //     final feedbacksSnapshot = await firestore
  //         .collection(FirebaseConstants.feedbackCollection)
  //         .where('providerId', isEqualTo: userId)
  //         .get();
  //     Log.info(
  //         "Feedback Provider id====> ${feedbacksSnapshot.docs.map((f) => f.data()['providerId'])}");
  //     Log.info(
  //         "Feedback Provider Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['requestFeedback'])}");

  //     Log.info(
  //         "Feedback Provider Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['provideFeedback'])}");
  //     Log.info(
  //         "Feedback Provider Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['ownerSideStatus'])}");
  //     Log.info(
  //         "Feedback Provider Snapshot====> ${feedbacksSnapshot.docs.map((f) => f.data()['providerSideStatus'])}");

  //     final feedbacks = feedbacksSnapshot.docs.map((f) {
  //       Log.info(f.data().toString());
  //       return FeedbackModel.fromMap(f.data());
  //     }).toList();
  //     state = state.copyWith(
  //         allFeedbackAsProvider: feedbacks, state: AsyncState.success);
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //     state = state.copyWith(error: e.toString(), state: AsyncState.failure);
  //   }
  // }

  Future<void> createFeedbackRequest(
      {required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final projectNotifier = ref.read(projectProgressProvider.notifier);
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
          .doc(feedback.ownerId)
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .set({'id': feedbackId});

      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(fb.providerId)
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
      fetchAllFeedbacks(userId: userId);
      projectNotifier.addProgress(
        projectId: feedback.project!.id!,
        projectTimeline: ProjectTimelineModel(
          message:
              "Feedback Requested by ${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName}",
          modifiedAt: DateTime.now().toString(),
        ),
      );
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> provideFeedback({
    required String feedbackId,
    required String projectId,
    required ProvideModel provideFeedback,
    required UserModel user,
    void Function()? callback,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final projectNotifier = ref.read(projectProgressProvider.notifier);
    final date = DateTime.now().toString();

    try {
      state = state.copyWith(state: AsyncState.loading);

      final doc = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .get();
      if (doc.exists) {
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedbackId)
            .update({
          "ownerSideStatus": Status(
            status: FeedbackStatus.received.name.toTitleCase(),
            modifiedAt: date,
          ).toMap(),
          'provideFeedback': provideFeedback.toMap(),
        });
        // await firestore
        //     .collection(FirebaseConstants.feedbackCollection)
        //     .doc(feedback.id)
        //     .update({'provideFeedback': feedback.provideFeedback!.toMap()});
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacks(userId: user.id!);
      projectNotifier.addProgress(
        projectId: projectId,
        projectTimeline: ProjectTimelineModel(
          message: "Feedback Received from ${user.firstName} ${user.lastName}",
          modifiedAt: date,
        ),
      );
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> appliedFeedback({
    required FeedbackModel feedback,
    required AppliedModel appliedFeedback,
    void Function()? callback,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final projectNotifier = ref.read(projectProgressProvider.notifier);
    final date = DateTime.now().toString();

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
            .update({
          "ownerSideStatus": Status(
            status: FeedbackStatus.applied.name.toTitleCase(),
            modifiedAt: date,
          ).toMap(),
          "providerSideStatus": Status(
            status: FeedbackStatus.provided.name.toTitleCase(),
            modifiedAt: date,
          ).toMap(),
          "appliedFeedback": appliedFeedback.toMap()
        });
        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(feedback.ownerId)
            .update({
          "feedbackApplied": FieldValue.increment(1),
          "totalFeedbackAccepted": FieldValue.increment(1),
        });

        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(feedback.providerId)
            .update({
          "feedbackProvided": FieldValue.increment(1),
        });
        if (feedback.requestFeedback!.cost == 0) {
          await firestore
              .collection(FirebaseConstants.userCollection)
              .doc(feedback.providerId)
              .update({
            "totalFeedbackProvidedForFree": FieldValue.increment(1),
          });
        }
        // await firestore
        //     .collection(FirebaseConstants.feedbackCollection)
        //     .doc(feedback.id)
        //     .update({});
        await firestore
            .collection(FirebaseConstants.feedbackCollection)
            .doc(feedback.id)
            .update({'lastUpdated': FieldValue.serverTimestamp()});

        await firestore
            .collection(FirebaseConstants.projectCollection)
            .doc(feedback.project?.id)
            .update({'completionPercentage': 100.0});
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacks(userId: ref.watch(currentUserProvider)!.id!);
      projectNotifier.addProgress(
        projectId: feedback.project!.id!,
        projectTimeline: ProjectTimelineModel(
          message:
              "Feedback Applied by ${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName}",
          modifiedAt: DateTime.now().toString(),
        ),
      );
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

        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(feedback.ownerId)
            .update({
          "totalFeedbackDeclined": FieldValue.increment(1),
        });
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> submitStatusReport(
      {required FeedbackModel feedback, void Function()? callback}) async {
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
            .update({'statusReport': feedback.statusReport!.toMap()});
      } else {
        state = state.copyWith(
            error: "Feedback doesn't exist!", state: AsyncState.failure);
      }
      fetchAllFeedbacks(userId: feedback.ownerId!);
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
  final List<FeedbackModel>? allFeedback;
  final AsyncState state;

  FeedbackNotifierState({
    this.error,
    this.allFeedback,
    required this.state,
  });

  FeedbackNotifierState copyWith({
    String? error,
    List<FeedbackModel>? allFeedback,
    AsyncState? state,
  }) {
    return FeedbackNotifierState(
      error: error ?? this.error,
      allFeedback: allFeedback ?? this.allFeedback,
      state: state ?? this.state,
    );
  }
}

class ECFNotifier extends Notifier<ECFNotifierState> {
  @override
  ECFNotifierState build() {
    return ECFNotifierState(state: AsyncState.initial);
  }

  Future<void> postErrorMessage(
      {required EcfModel ecf,
      required String feedbackId,
      void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);

      await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .collection(FirebaseConstants.ecfCollection)
          .add(ecf.toMap());
      fetchErrorMessages(feedbackId: feedbackId);
      // fetchAllFeedbacksAsProvider(userId: userId);
      // fetchAllOwnFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchErrorMessages(
      {required String feedbackId, void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(state: AsyncState.loading);

      final ecfSnapshots = await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedbackId)
          .collection(FirebaseConstants.ecfCollection)
          .get();

      List<EcfModel> errorMessages =
          ecfSnapshots.docs.map((e) => EcfModel.fromMap(e.data())).toList();
      callback?.call();
      state = state.copyWith(data: errorMessages, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class ECFNotifierState {
  final AsyncState state;
  final List<EcfModel>? data;
  final String? error;
  ECFNotifierState({
    required this.state,
    this.data,
    this.error,
  });

  ECFNotifierState copyWith({
    AsyncState? state,
    List<EcfModel>? data,
    String? error,
  }) {
    return ECFNotifierState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
