import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/new_project_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedback_work/core/utils/utils.dart';

final projectProgressProvider =
    NotifierProvider<ProjectProgressNotifier, ProjectProgressNotifierState>(
        ProjectProgressNotifier.new);

class ProjectProgressNotifier extends Notifier<ProjectProgressNotifierState> {
  @override
  ProjectProgressNotifierState build() {
    return ProjectProgressNotifierState(state: AsyncState.initial);
  }

  Future<void> addProgress({
    required String projectId,
    required ProjectTimelineModel projectTimeline,
    void Function()? callBack,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    final projectNotifier = ref.read(projectProvider.notifier);
    try {
      final projectDoc = await firestore
          .collection(FirebaseConstants.projectCollection)
          .doc(projectId)
          .get();
      if (!projectDoc.exists) {
        throw Exception("Project not found");
      }
      await firestore
          .collection(FirebaseConstants.projectCollection)
          .doc(projectId)
          .collection(FirebaseConstants.projectTimelineCollection)
          .doc(projectTimeline.modifiedAt)
          .set(projectTimeline.toMap());
      // projectNotifier.fetchProjectById(projectId: projectId);
      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchProgress({
    required String projectId,
    void Function()? callBack,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final projectDoc = await firestore
          .collection(FirebaseConstants.projectCollection)
          .doc(projectId)
          .get();
      if (!projectDoc.exists) {
        throw Exception("Project not found");
      }
      final snapshots = await firestore
          .collection(FirebaseConstants.projectCollection)
          .doc(projectId)
          .collection(FirebaseConstants.projectTimelineCollection)
          .get();
      final List<ProjectTimelineModel> projectsTimeline = snapshots.docs
          .map((p) => ProjectTimelineModel.fromMap(p.data()))
          .toList();
      callBack?.call();
      state = state.copyWith(
        state: AsyncState.success,
        projectProgress: projectsTimeline,
      );
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class ProjectProgressNotifierState {
  final String? error;
  final List<ProjectTimelineModel>? projectProgress;
  final AsyncState state;

  ProjectProgressNotifierState({
    this.error,
    this.projectProgress,
    required this.state,
  });

  ProjectProgressNotifierState copyWith({
    String? error,
    final List<ProjectTimelineModel>? projectProgress,
    AsyncState? state,
  }) {
    return ProjectProgressNotifierState(
      error: error ?? this.error,
      projectProgress: projectProgress ?? this.projectProgress,
      state: state ?? this.state,
    );
  }
}
