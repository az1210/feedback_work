import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/project_progress_provider.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';

final requestFeedbackStepProvider = StateProvider<int>((ref) => 1);
final provideFeedbackStepProvider = StateProvider<int>((ref) => 1);

final feedbackProvider =
    NotifierProvider<FeedbackNotifier, FeedbackNotifierState>(
        FeedbackNotifier.new);
final ecfProvider =
    NotifierProvider<ECFNotifier, ECFNotifierState>(ECFNotifier.new);

class FeedbackNotifier extends Notifier<FeedbackNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  FeedbackNotifierState build() {
    return FeedbackNotifierState(state: AsyncState.initial);
  }

  Future<void> fetchAllFeedbacks({required String userId}) async {
    Log.info("Fetch all own feedback called");
    Log.info("User ID: $userId");

    try {
      state = state.copyWith(state: AsyncState.loading);
      List<FeedbackModel> allFeedbacks = [];

      // Get feedbacks where user is owner
      final ownerFeedbacks =
          await supabase.from('feedbacks').select().eq('ownerId', userId);

      allFeedbacks.addAll((ownerFeedbacks as List)
          .map((data) => FeedbackModel.fromMap(data))
          .toList());

      // Get feedbacks where user is provider
      final providerFeedbacks =
          await supabase.from('feedbacks').select().eq('providerId', userId);

      allFeedbacks.addAll((providerFeedbacks as List)
          .map((data) => FeedbackModel.fromMap(data))
          .toList());

      state =
          state.copyWith(allFeedback: allFeedbacks, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> createFeedbackRequest(
      {required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      const uuid = Uuid();
      final feedbackId = uuid.v1();
      final date = DateTime.now().toString();

      final fb = feedback.copyWith(
        id: feedbackId,
        ownerSideStatus: Status(
          status: FeedbackStatus.requested.name.toTitleCase(),
          modifiedAt: date,
        ),
        providerSideStatus: Status(
          status: FeedbackStatus.requested.name.toTitleCase(),
          modifiedAt: date,
        ),
      );

      // Create feedback
      await supabase.from('feedbacks').insert(fb.toMap());

      // Create user-feedback relationships
      await supabase.from('user_feedbacks').insert([
        {'user_id': feedback.ownerId, 'feedback_id': feedbackId},
        {'user_id': fb.providerId, 'feedback_id': feedbackId}
      ]);

      // Add to group if group feedback
      if (feedback.requestFeedback?.groupId != '') {
        await supabase.from('group_feedbacks').insert({
          'group_id': feedback.requestFeedback!.groupId,
          'feedback_id': feedbackId
        });
      }

      await fetchAllFeedbacks(userId: userId);

      // Add project progress
      final projectNotifier = ref.read(projectProgressProvider.notifier);
      projectNotifier.addProgress(
        projectId: feedback.project!.id!,
        projectTimeline: ProjectTimelineModel(
          message:
              "Feedback Requested by ${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName}",
          modifiedAt: date,
        ),
      );

      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> provideFeedback({
    required String feedbackId,
    required String projectId,
    required ProvideModel provideFeedback,
    required UserModel user,
    void Function()? callback,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      final date = DateTime.now().toString();

      // Update feedback status and add provide feedback
      await supabase.from('feedbacks').update({
        'ownerSideStatus': Status(
          status: FeedbackStatus.received.name.toTitleCase(),
          modifiedAt: date,
        ).toMap(),
        'provideFeedback': provideFeedback.toMap(),
      }).eq('id', feedbackId);

      await fetchAllFeedbacks(userId: user.id!);

      // Add project progress
      final projectNotifier = ref.read(projectProgressProvider.notifier);
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
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> appliedFeedback({
    required FeedbackModel feedback,
    required AppliedModel appliedFeedback,
    void Function()? callback,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      final date = DateTime.now().toString();

      // Begin transaction
      await supabase.rpc('apply_feedback', params: {
        'feedback_id': feedback.id,
        'owner_id': feedback.ownerId,
        'provider_id': feedback.providerId,
        'status_date': date,
        'owner_status': FeedbackStatus.applied.name.toTitleCase(),
        'provider_status': FeedbackStatus.provided.name.toTitleCase(),
        'applied_feedback': appliedFeedback.toMap(),
        'is_free': feedback.requestFeedback!.cost == 0,
        'project_id': feedback.project?.id,
      });

      await fetchAllFeedbacks(userId: ref.watch(currentUserProvider)?.id ?? '');

      // Add project progress
      final projectNotifier = ref.read(projectProgressProvider.notifier);
      projectNotifier.addProgress(
        projectId: feedback.project!.id!,
        projectTimeline: ProjectTimelineModel(
          message:
              "Feedback Applied by ${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName}",
          modifiedAt: date,
        ),
      );

      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> declineFeedback(
      {required EcfModel ecf,
      required FeedbackModel feedback,
      required String userId,
      void Function()? callback}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Add ECF and update status
      await supabase.rpc('decline_feedback', params: {
        'feedback_id': feedback.id,
        'owner_id': feedback.ownerId,
        'ecf_data': ecf.toMap(),
        'status_date': DateTime.now().toString(),
        'provider_status': FeedbackStatus.requested.name.toTitleCase(),
      });

      await fetchAllFeedbacks(userId: userId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> submitStatusReport(
      {required FeedbackModel feedback, void Function()? callback}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      if (feedback.id == null) {
        throw Exception('Feedback ID cannot be null');
      }
      await supabase
          .from('feedbacks')
          .update({'statusReport': feedback.statusReport!.toMap()}).eq(
              'id', feedback.id as String);

      await fetchAllFeedbacks(userId: feedback.ownerId!);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
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
  final supabase = Supabase.instance.client;

  @override
  ECFNotifierState build() {
    return ECFNotifierState(state: AsyncState.initial);
  }

  Future<void> postErrorMessage(
      {required EcfModel ecf,
      required String feedbackId,
      void Function()? callback}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      await supabase
          .from('ecfs')
          .insert({...ecf.toMap(), 'feedback_id': feedbackId});

      await fetchErrorMessages(feedbackId: feedbackId);
      callback?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchErrorMessages(
      {required String feedbackId, void Function()? callback}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      final response =
          await supabase.from('ecfs').select().eq('feedback_id', feedbackId);

      final errorMessages =
          (response as List).map((data) => EcfModel.fromMap(data)).toList();

      callback?.call();
      state = state.copyWith(data: errorMessages, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
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
