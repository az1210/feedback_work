// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// import 'package:go_router/go_router.dart';
// import '../../providers/project_providers.dart'; // Import your project_providers.dart

// class ProjectsScreen extends ConsumerWidget {
//   const ProjectsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final projectService = ref.watch(projectServiceProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Projects'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.grid_view),
//             onPressed: () {
//               // Toggle between list/grid view (can add toggle logic here)
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('projects').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final projects = snapshot.data!.docs;

//           if (projects.isEmpty) {
//             return const Center(child: Text('No projects found.'));
//           }

//           return GridView.builder(
//             padding: const EdgeInsets.all(8.0),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 1,
//               mainAxisSpacing: 8,
//               crossAxisSpacing: 8,
//             ),
//             itemCount: projects.length,
//             itemBuilder: (context, index) {
//               final project = projects[index].data() as Map<String, dynamic>;
//               final projectId = projects[index].id;

//               return ProjectCard(
//                 projectId: projectId,
//                 project: project,
//                 projectService: projectService,
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to Create Project Screen
//           context.push('/create-project');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class ProjectCard extends StatelessWidget {
//   final String projectId;
//   final Map<String, dynamic> project;
//   final ProjectService projectService;

//   const ProjectCard({
//     Key? key,
//     required this.projectId,
//     required this.project,
//     required this.projectService,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap: () {
//           // Navigate to expanded project details screen
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ExpandedProjectDetails(
//                 projectId: projectId,
//                 project: project,
//                 projectService: projectService,
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 project['projectName'] ?? 'No Name',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Problem: ${project['problemName'] ?? 'Unknown'}',
//                 style: const TextStyle(color: Colors.red),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 'Solution: ${project['solutionName'] ?? 'Unknown'}',
//                 style: const TextStyle(color: Colors.green),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const Spacer(),
//               Text(
//                 DateFormat('dd/MM/yyyy').format(
//                   (project['createdAt'] as Timestamp).toDate(),
//                 ),
//                 style: const TextStyle(fontSize: 12),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle request feedback
//                 },
//                 child: const Text('Request Feedback'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ExpandedProjectDetails extends StatelessWidget {
//   final String projectId;
//   final Map<String, dynamic> project;
//   final ProjectService projectService;

//   const ExpandedProjectDetails({
//     super.key,
//     required this.projectId,
//     required this.project,
//     required this.projectService,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(project['projectName'] ?? 'Project Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to edit project screen
//               Navigator.pushNamed(context, '/edit-project', arguments: {
//                 'projectId': projectId,
//                 'project': project,
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () async {
//               // Confirm and delete project
//               final confirm = await showDialog<bool>(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text('Delete Project'),
//                     content: const Text(
//                         'Are you sure you want to delete this project?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: const Text('Delete'),
//                       ),
//                     ],
//                   );
//                 },
//               );

//               if (confirm == true) {
//                 await projectService.deleteProject(projectId: projectId);
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Problem: ${project['problemName'] ?? 'Unknown'}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Solution: ${project['solutionName'] ?? 'Unknown'}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Status: ${project['status'] ?? 'Not Started'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle request feedback logic here
//               },
//               child: const Text('Request Feedback'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../providers/project_providers.dart';
import 'package:go_router/go_router.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final projectService = ref.watch(projectServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Grayish background
      appBar: AppBar(
        title: const Text('Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              // Optional: Toggle between views
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...projects.map((doc) {
                final project = doc.data() as Map<String, dynamic>;
                final projectId = doc.id;

                return ProjectCard(
                  projectId: projectId,
                  project: project,
                  projectService: projectService,
                );
              }),
              const SizedBox(height: 16),
              // Create Project Button as Card
              InkWell(
                onTap: () {
                  // Navigate to Create Project Screen
                  context.push('/create-project');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, size: 48, color: Colors.blue),
                      SizedBox(height: 8),
                      Text(
                        'Create Project',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedFontSize: 16,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 88, 88, 88),
        unselectedFontSize: 12,
        currentIndex: 0, // Current tab index
        onTap: (index) {
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                'assets/images/icons/project-tab.png',
              ),
              size: 20,
            ),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/icons/feedback-tab.png'),
            ),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/icons/network-tab.png'),
            ),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/icons/status-tab.png'),
            ),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/icons/more-tab.png'),
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
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
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Collapse Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['projectName'] ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        (project['createdAt'] as Timestamp).toDate(),
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(_isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            // Collapsible Content
            if (_isExpanded) ...[
              _buildProjectDetailRow(
                  'Problem:', project['problemName'], Colors.red),
              _buildProjectDetailRow(
                  'Solution:', project['solutionName'], Colors.green),
              _buildProjectDetailRow('Solution Function:',
                  project['solutionFunctionName'], Colors.black),
              const SizedBox(height: 8),
              Text(
                'Status: ${project['status'] ?? 'Not Started'}',
                style: const TextStyle(color: Colors.blue),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  // Handle Request Feedback
                },
                child: const Text('Request Feedback'),
              ),
            ] else
              Text(
                'Status: ${project['status'] ?? 'Not Started'}',
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailRow(String title, String? value, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
