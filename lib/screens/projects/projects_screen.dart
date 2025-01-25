import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/new_project_providers.dart';
import 'package:feedback_work/screens/projects/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../providers/project_providers.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  List<ProjectModel> projects = [];

  @override
  void initState() {
    Future.microtask(() {
      final auth = ref.read(firebaseAuthProvider);
      ref
          .read(projectProvider.notifier)
          .fetchAllProjects(userId: auth.currentUser!.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    ref.listen(projectProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        projects = newState.allUsersProjects!;
      }
      Log.info(projects.last.toMap().toString());
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Project',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              ref
                  .read(feedbackProvider.notifier)
                  .deleteCollection(FirebaseConstants.projectCollection);
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          if (projectState == AsyncState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (projectState.error != null) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            if (projects.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'No projects found yet.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        context.push('/create-project');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle,
                                size: 35, color: Color(0xFF0866ff)),
                            const SizedBox(height: 5),
                            Text(
                              'Create Project',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xFF0866ff),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...projects.map((doc) {
                  final project = doc;
                  final projectId = doc.id;

                  return ProjectCard(
                    projectId: projectId ?? '',
                    project: project,
                  );
                }),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    context.pushNamed(Routes.createProject);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle,
                            size: 35, color: Color(0xFF0866ff)),
                        const SizedBox(height: 5),
                        Text(
                          'Create Project',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xFF0866ff),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }
        },
      ),
    );
  }
}
