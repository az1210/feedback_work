import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/project_progress_provider.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:feedback_work/core/utils/utils.dart';

final projectProvider = NotifierProvider<ProjectNotifier, ProjectNotifierState>(
    ProjectNotifier.new);

class ProjectNotifier extends Notifier<ProjectNotifierState> {
  final supabase = Supabase.instance.client;

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
    try {
      const uuid = Uuid();
      final docId = uuid.v4();

      // Check if user exists
      final userResponse = await supabase
          .from('users')
          .select()
          .eq('id', project.ownerId)
          .single();

      if (userResponse == null) {
        throw Exception("User not found");
      }

      // Create project with all parameters
      final projectData = {
        'id': docId,
        'title': project.title,
        'description': project.description,
        'owner_id': project.ownerId,
        'status': project.status,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'start_date_time': project.startDateTime,
        'finish_date_time': project.finishDateTime,
        'completion_percentage': project.completionPercentage,
        'project_name':
            project.title, // Use title as project name if not specified
        'problem_name': project.problemName,
        'solution_name': project.solutionName,
        'solution_function_name': project.solutionFunctionName
      };

      await supabase.from('projects').insert(projectData);

      // Add initial timeline entry
      await supabase.from('project_timelines').insert({
        'project_id': docId,
        'message': "Project Started",
        'modified_at': DateTime.now().toIso8601String(),
      });

      // Fetch updated projects
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser?.id != null) {
        await fetchUserProjects(userId: currentUser!.id!);
      }

      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchAllProjects() async {
    state = state.copyWith(state: AsyncState.loading);
    try {
      final response =
          await supabase.from('projects').select().order('created_at');

      final projects =
          (response as List).map((data) => ProjectModel.fromMap(data)).toList();
      state =
          state.copyWith(allUsersProjects: projects, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
    }
  }

  Future<void> fetchUserProjects({required String userId}) async {
    try {
      state = state.copyWith(state: AsyncState.loading);

      // Use the projects_with_users view instead of trying to join manually
      final response = await supabase
          .from('projects_with_users')
          .select()
          .eq('owner_id', userId);

      final projects = (response as List).map((data) {
        // Create owner object from user fields
        final owner = UserModel(
          id: data['user_id'],
          email: data['email'],
          firstName: data['first_name'],
          lastName: data['last_name'],
          phoneNumber: data['phone_number'],
          username: data['username'],
          avatarUrl: data['avatar_url'],
          title: data['user_title'],
          expertise: data['expertise'],
          accountType: data['account_type'],
          createdAt: data['user_created_at'] != null
              ? DateTime.parse(data['user_created_at'])
              : null,
          minimumRate: double.tryParse(data['minimum_rate'] ?? '0'),
        );

        // Create project with owner
        return ProjectModel.fromMap({
          ...data,
          'owner': owner.toMap(),
        });
      }).toList();

      state = state.copyWith(
          currentUserProjects: projects, state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(state: AsyncState.failure, error: e.toString());
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
