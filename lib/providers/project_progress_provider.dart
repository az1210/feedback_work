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
      // Check if project exists
      final project =
          await supabase.from('projects').select().eq('id', projectId).single();

      if (project == null) {
        throw Exception("Project not found");
      }

      // Add timeline entry
      await supabase.from('project_timelines').insert({
        ...projectTimeline.toMap(),
        'project_id': projectId,
      });

      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchProgress({
    required String projectId,
    void Function()? callBack,
  }) async {
    try {
      // Check if project exists
      final project =
          await supabase.from('projects').select().eq('id', projectId).single();

      if (project == null) {
        throw Exception("Project not found");
      }

      // Get timeline entries
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
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
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
