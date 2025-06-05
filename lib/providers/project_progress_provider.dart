import 'package:feedback_work/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedback_work/core/utils/utils.dart';

final projectProgressProvider =
    NotifierProvider<ProjectProgressNotifier, ProjectProgressNotifierState>(
        ProjectProgressNotifier.new);

class ProjectProgressNotifier extends Notifier<ProjectProgressNotifierState> {
  final supabase = Supabase.instance.client;

  @override
  ProjectProgressNotifierState build() {
    return ProjectProgressNotifierState(state: AsyncState.initial);
  }

  Future<void> addProgress({
    required String projectId,
    required ProjectTimelineModel projectTimeline,
    void Function()? callBack,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Add timeline entry - RLS will handle permission check
      await supabase.from('project_timelines').insert({
        ...projectTimeline.toMap(),
        'project_id': projectId,
      });

      // Fetch updated progress
      await fetchProgress(projectId: projectId);

      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
        projectProgress: [], // Return empty list on error
      );
    }
  }

  Future<void> fetchProgress({
    required String projectId,
    void Function()? callBack,
  }) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Get timeline entries - RLS will handle permission check
      final response = await supabase
          .from('project_timelines')
          .select()
          .eq('project_id', projectId)
          .order('modified_at');

      final projectsTimeline = (response as List)
          .map((data) => ProjectTimelineModel.fromMap(data))
          .toList();

      callBack?.call();
      state = state.copyWith(
        state: AsyncState.success,
        projectProgress: projectsTimeline,
      );
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(
        state: AsyncState.failure,
        error: e.toString(),
        projectProgress: [], // Return empty list on error
      );
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
