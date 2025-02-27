import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/project_progress_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedback_work/core/utils/utils.dart';

final projectProvider = NotifierProvider<ProjectNotifier, ProjectNotifierState>(
    ProjectNotifier.new);

class ProjectNotifier extends Notifier<ProjectNotifierState> {
  @override
  ProjectNotifierState build() {
    return ProjectNotifierState(state: AsyncState.initial);
  }

  Future<void> createProject({
    required ProjectModel project,
    void Function()? callBack,
  }) async {
    Log.info(project.owner!.toMap().toString());
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final progressNotifier = ref.read(projectProgressProvider.notifier);
    try {
      final docId = DateTime.now().millisecondsSinceEpoch.toString();
      final userDoc = await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(project.ownerId)
          .get();
      if (!userDoc.exists) {
        throw Exception("User not found");
      }
      await firestore
          .collection(FirebaseConstants.projectCollection)
          .doc(docId)
          .set(project.copyWith(id: docId).toMap());

      progressNotifier
          .addProgress(
        projectId: docId,
        projectTimeline: ProjectTimelineModel(
          message: "Project Started",
          modifiedAt: DateTime.now().toString(),
        ),
      )
          .then((_) {
        fetchAllProjects(userId: project.owner!.id!);
      });
      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchAllProjects({required String userId}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final usersSnapshot = await firestore
          .collection(FirebaseConstants.projectCollection)
          .where('ownerId', isEqualTo: userId)
          .get();
      final projects = usersSnapshot.docs
          .map((u) => ProjectModel.fromMap(u.data()))
          .toList();
      state =
          state.copyWith(allUsersProjects: projects, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchUserProjects({required String userId}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollection)
          .where('ownerId', isEqualTo: userId)
          .orderBy('createAt')
          .get();

      // Map each document to a list of user data
      List<ProjectModel> projects = querySnapshot.docs
          .map(
              (doc) => ProjectModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
          currentUserProjects: projects, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchProjectById({required String projectId}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollection)
          .doc(projectId)
          .get();

      // Map each document to a list of user data
      ProjectModel projects =
          ProjectModel.fromMap(snapshot.data() as Map<String, dynamic>);
      state = state
          .copyWith(currentUserProjects: [projects], state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class ProjectNotifierState {
  final String? error;
  final List<ProjectModel>? allUsersProjects;
  final List<ProjectModel>? currentUserProjects;
  final AsyncState state;

  ProjectNotifierState({
    this.error,
    this.allUsersProjects,
    this.currentUserProjects,
    required this.state,
  });

  ProjectNotifierState copyWith({
    String? error,
    final List<ProjectModel>? allUsersProjects,
    final List<ProjectModel>? currentUserProjects,
    AsyncState? state,
  }) {
    return ProjectNotifierState(
      error: error ?? this.error,
      allUsersProjects: allUsersProjects ?? this.allUsersProjects,
      currentUserProjects: currentUserProjects ?? this.currentUserProjects,
      state: state ?? this.state,
    );
  }
}
