import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting dates
import '../../providers/project_providers.dart'; // Import your project_providers.dart

class ProjectsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectService = ref.watch(projectServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              // Toggle between list/grid view (can add toggle logic here)
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final projects = snapshot.data!.docs;

          if (projects.isEmpty) {
            return const Center(child: Text('No projects found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index].data() as Map<String, dynamic>;
              final projectId = projects[index].id;

              return ProjectCard(
                projectId: projectId,
                project: project,
                projectService: projectService,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create Project Screen
          Navigator.pushNamed(context, '/create-project');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String projectId;
  final Map<String, dynamic> project;
  final ProjectService projectService;

  const ProjectCard({
    Key? key,
    required this.projectId,
    required this.project,
    required this.projectService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to expanded project details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpandedProjectDetails(
                projectId: projectId,
                project: project,
                projectService: projectService,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project['projectName'] ?? 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Problem: ${project['problemName'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Solution: ${project['solutionName'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.green),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy').format(
                  (project['createdAt'] as Timestamp).toDate(),
                ),
                style: const TextStyle(fontSize: 12),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle request feedback
                },
                child: const Text('Request Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedProjectDetails extends StatelessWidget {
  final String projectId;
  final Map<String, dynamic> project;
  final ProjectService projectService;

  const ExpandedProjectDetails({
    super.key,
    required this.projectId,
    required this.project,
    required this.projectService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project['projectName'] ?? 'Project Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit project screen
              Navigator.pushNamed(context, '/edit-project', arguments: {
                'projectId': projectId,
                'project': project,
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Confirm and delete project
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Project'),
                    content: const Text(
                        'Are you sure you want to delete this project?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await projectService.deleteProject(projectId: projectId);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problem: ${project['problemName'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Solution: ${project['solutionName'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${project['status'] ?? 'Not Started'}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle request feedback logic here
              },
              child: const Text('Request Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
