// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// import '../../providers/project_providers.dart';
// import 'package:go_router/go_router.dart';

// class ProjectsScreen extends ConsumerStatefulWidget {
//   const ProjectsScreen({super.key});

//   @override
//   ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
// }

// class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
//   int _currentIndex = 0;

//   final List<String> _routes = [
//     '/projects',
//     '/feedback',
//     '/network',
//     '/status',
//     '/more',
//   ];

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   // Use the custom location getter to determine the current route
//   //   final currentLocation = GoRouter.of(context).location;

//   //   // Update the index based on the current route
//   //   _updateIndexFromLocation(currentLocation);
//   // }

//   // void _updateIndexFromLocation(String location) {
//   //   final index = _routes.indexOf(location);
//   //   if (index != -1 && _currentIndex != index) {
//   //     setState(() {
//   //       _currentIndex = index;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final projectService = ref.watch(projectServiceProvider);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 240, 242, 245),
//       appBar: AppBar(
//         title: Text(
//           'Projects',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.grid_view),
//             onPressed: () {
//               // Toggle between views
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

//           return ListView(
//             padding:
//                 const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
//             children: [
//               ...projects.map((doc) {
//                 final project = doc.data() as Map<String, dynamic>;
//                 final projectId = doc.id;

//                 return ProjectCard(
//                   projectId: projectId,
//                   project: project,
//                   projectService: projectService,
//                 );
//               }),
//               const SizedBox(height: 20),
//               InkWell(
//                 onTap: () {
//                   context.push('/create-project');
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5),
//                     // boxShadow: [
//                     //   BoxShadow(
//                     //     color: Colors.black.withOpacity(0.1),
//                     //     blurRadius: 5,
//                     //     offset: const Offset(0, 2),
//                     //   ),
//                     // ],
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add_circle,
//                           size: 48, color: Color(0xFF0866ff)),
//                       SizedBox(height: 8),
//                       Text(
//                         'Create Project',
//                         style: TextStyle(
//                           fontSize: 24,
//                           // fontWeight: FontWeight.bold,
//                           color: Color(0xFF0866ff),
//                           letterSpacing: 0.8,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25)
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 82,
//         child: BottomNavigationBar(
//           showUnselectedLabels: true,
//           selectedIconTheme: const IconThemeData(
//             size: 30,
//           ),
//           unselectedIconTheme: const IconThemeData(size: 23),
//           selectedLabelStyle: const TextStyle(
//             fontFamily: "Inter",
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontFamily: "Inter",
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//           ),
//           selectedItemColor: const Color.fromARGB(255, 8, 102, 255),
//           unselectedItemColor: const Color.fromARGB(255, 101, 103, 107),
//           currentIndex: _currentIndex, // Current tab index
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//             context.go(_routes[index]);
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: ImageIcon(
//                 AssetImage(
//                   'assets/images/icons/nav-tab/tabIcon2.png',
//                 ),
//               ),
//               label: 'Projects',
//             ),
//             BottomNavigationBarItem(
//               icon: ImageIcon(
//                 AssetImage('assets/images/icons/feedback-tab.png'),
//               ),
//               label: 'Feedback',
//             ),
//             BottomNavigationBarItem(
//               icon: ImageIcon(
//                 AssetImage('assets/images/icons/network-tab.png'),
//               ),
//               label: 'Network',
//             ),
//             BottomNavigationBarItem(
//               icon: ImageIcon(
//                 AssetImage('assets/images/icons/status-tab.png'),
//               ),
//               label: 'Status',
//             ),
//             BottomNavigationBarItem(
//               icon: ImageIcon(
//                 AssetImage('assets/images/icons/more-tab.png'),
//               ),
//               label: 'More',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProjectCard extends StatefulWidget {
//   final String projectId;
//   final Map<String, dynamic> project;
//   final ProjectService projectService;

//   const ProjectCard({
//     super.key,
//     required this.projectId,
//     required this.project,
//     required this.projectService,
//   });

//   @override
//   State<ProjectCard> createState() => _ProjectCardState();
// }

// class _ProjectCardState extends State<ProjectCard> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final project = widget.project;

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             color: const Color.fromARGB(255, 235, 245, 255),
//             child: Padding(
//               padding:
//                   const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 12),
//                       Text(project['projectName'] ?? 'No Name',
//                           style: Theme.of(context).textTheme.titleMedium),
//                       const SizedBox(height: 8),
//                       Text(
//                         DateFormat('dd/MM/yyyy').format(
//                           (project['createdAt'] as Timestamp).toDate(),
//                         ),
//                         style: const TextStyle(
//                             fontFamily: "Inter",
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             fontStyle: FontStyle.italic),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isExpanded = !_isExpanded; // Toggle the expanded state
//                       });
//                     },
//                     child: _isExpanded
//                         ? Image.asset("assets/images/icons/up-arrow.png",
//                             height: 8)
//                         : Image.asset("assets/images/icons/down-arrow.png",
//                             height: 8), // Regular icon when not expanded
//                   )
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Collapsible Content
//           if (_isExpanded) ...[
//             _buildProjectDetailRow(
//                 'Problem:', project['problemName'], Colors.red),
//             _buildProjectDetailRow(
//                 'Solution:', project['solutionName'], Colors.green),
//             _buildProjectDetailRow('Solution Function:',
//                 project['solutionFunctionName'], Colors.black),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Text(
//                 'Status: ${project['status'] ?? 'Not Started'}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//             // const Divider(),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 8, 102, 255),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Request Feedback',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ] else
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Text(
//                 'Status: ${project['status'] ?? 'Not Started'}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProjectDetailRow(String title, String? value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               value ?? 'N/A',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium
//                   ?.copyWith(color: color),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../providers/project_providers.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
    '/status',
    '/more',
  ];

  @override
  Widget build(BuildContext context) {
    final projectService = ref.watch(projectServiceProvider);

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
            onPressed: () {
              // Handle toggle between views
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
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
              const SizedBox(height: 24),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 23),
          selectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          selectedItemColor: const Color.fromARGB(255, 8, 102, 255),
          unselectedItemColor: const Color.fromARGB(255, 101, 103, 107),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            context.go(_routes[index]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icons/nav-tab/tabIcon2.png'),
                size: 30,
              ),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage('assets/images/icons/feedback-tab.png')),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage('assets/images/icons/network-tab.png')),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/icons/status-tab.png')),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/icons/more-tab.png')),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String projectId;
  final Map<String, dynamic> project;
  final ProjectService projectService;

  const ProjectCard({
    super.key,
    required this.projectId,
    required this.project,
    required this.projectService,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;
  bool _isProgressExpanded = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                color: const Color.fromARGB(255, 235, 245, 255),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['projectName'] ?? 'No Name',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(
                              (project['createdAt'] as Timestamp).toDate(),
                            ),
                            style: const TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: _isExpanded
                            ? Image.asset("assets/images/icons/up-arrow.png",
                                height: 8)
                            : Image.asset("assets/images/icons/down-arrow.png",
                                height: 8),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 8),
                _buildDetailRow(
                    'Problem', project['problemName'] ?? 'N/A', Colors.red),
                _buildDetailRow(
                    'Solution', project['solutionName'] ?? 'N/A', Colors.green),
                _buildDetailRow('Solution Function',
                    project['solutionFunctionName'] ?? 'N/A', Colors.green),
                _buildDetailRow(
                  'Start Date',
                  project['startDate'] != null
                      ? DateFormat('dd/MM/yyyy')
                          .format((project['startDate'] as Timestamp).toDate())
                      : '01/01/2024, 5PM',
                  Colors.black54,
                ),
                _buildDetailRow(
                  'End Date',
                  project['endDate'] != null
                      ? DateFormat('dd/MM/yyyy')
                          .format((project['endDate'] as Timestamp).toDate())
                      : '05/01/2024, 5PM',
                  Colors.black54,
                ),
                _buildDetailRow(
                    'Total Feedback Requested',
                    '${project['feedbackRequested'] ?? 0}',
                    const Color.fromARGB(255, 8, 102, 255)),
                _buildDetailRow(
                    'Total Feedback Received',
                    '${project['feedbackReceived'] ?? 0}',
                    const Color.fromARGB(255, 8, 102, 255)),
                _buildDetailRow(
                    'Total Feedback Applied',
                    '${project['feedbackApplied'] ?? 0}',
                    const Color.fromARGB(255, 8, 102, 255)),
                _buildDetailRow(
                    'Status',
                    '${project['status'] ?? '10 % Completed'}',
                    const Color.fromARGB(255, 8, 102, 255)),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 102, 255),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Request Feedback',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ] else ...[
                _buildDetailRow(
                    'Problem', project['problemName'] ?? 'N/A', Colors.red),
                _buildDetailRow(
                    'Solution', project['solutionName'] ?? 'N/A', Colors.green),
                _buildDetailRow('Solution Function',
                    project['solutionFunctionName'] ?? 'N/A', Colors.green),
                _buildDetailRow(
                    'Status',
                    '${project['status'] ?? '10 % Completed'}',
                    const Color.fromARGB(255, 8, 102, 255)),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 102, 255),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Request Feedback',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding:
                const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Handle edit
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete_outline, color: Colors.black),
                      onPressed: () {
                        // Handle delete
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.share_outlined, color: Colors.black),
                      onPressed: () {
                        // Handle share
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Start action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0866FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 16, right: 8),
                  child: Row(
                    children: [
                      const Text(
                        "Check Progress",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isProgressExpanded = !_isProgressExpanded;
                          });
                        },
                        child: _isProgressExpanded
                            ? Image.asset("assets/images/icons/up-arrow.png",
                                height: 8)
                            : Image.asset("assets/images/icons/down-arrow.png",
                                height: 8),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
