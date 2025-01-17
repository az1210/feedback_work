import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/providers/project_providers.dart';
import 'package:feedback_work/screens/projects/widgets/check_progress_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatefulWidget {
  final String projectId;
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.projectId,
    required this.project,
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
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 233, 234, 240)),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                color: const Color.fromARGB(255, 235, 245, 255),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.projectName ?? 'No Name',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          project.createdAt is Timestamp
                              ? DateFormat('dd/MM/yyyy').format(
                                  (project.createdAt as Timestamp).toDate())
                              : 'N/A',
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
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: _isExpanded
                            ? Image.asset("assets/images/icons/up-arrow.png",
                                height: 10)
                            : Image.asset("assets/images/icons/down-arrow.png",
                                height: 10),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 4),
                _buildDetailRow(
                  'Problem',
                  project.problemName ?? 'N/A',
                  Colors.red,
                  () {},
                ),
                _buildDetailRow(
                  'Solution',
                  project.solutionName ?? 'N/A',
                  const Color.fromARGB(255, 0, 161, 76),
                  () {},
                ),
                _buildDetailRow(
                  'Solution Function',
                  project.solutionFunctionName ?? 'N/A',
                  const Color.fromARGB(255, 0, 161, 76),
                  () {
                    final projectId = widget.projectId;
                    context.push('/solution-function/$projectId');
                  },
                ),
                _buildDetailRow(
                  'Start Date',
                  project.startDateTime is Timestamp
                      ? DateFormat('dd/MM/yyyy')
                          .format((project.startDateTime as Timestamp).toDate())
                      : '01/01/2024, 5PM',
                  Colors.black54,
                  () {},
                ),
                _buildDetailRow(
                  'End Date',
                  project.finishDateTime is Timestamp
                      ? DateFormat('dd/MM/yyyy').format(
                          (project.finishDateTime as Timestamp).toDate())
                      : '05/01/2024, 5PM',
                  Colors.black54,
                  () {},
                ),
                _buildDetailRow(
                  'Total Feedback Requested', '0',
                  // TODO: Implement API
                  // '${project['feedbackRequested'] ?? 0}',
                  const Color.fromARGB(255, 0, 87, 255),
                  () {},
                ),
                _buildDetailRow(
                  'Total Feedback Received', '0',
                  // '${project['feedbackReceived'] ?? 0}',
                  const Color.fromARGB(255, 0, 87, 255),
                  () {},
                ),
                _buildDetailRow(
                  'Total Feedback Applied', '0',
                  // '${project['feedbackApplied'] ?? 0}',
                  const Color.fromARGB(255, 0, 87, 255),
                  () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${project.completionPercentage ?? '0'}% Completed',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 0, 87, 255),
                              ),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(Routes.requestFeedback, extra: project);
                    },
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
                ColoredBox(
                  color: _isProgressExpanded
                      ? Colors.white
                      : const Color.fromARGB(255, 240, 242, 245),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColoredBox(
                        color: const Color.fromARGB(255, 240, 242, 245),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16, bottom: 4, top: 4),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  final projectId = widget.projectId;
                                  context.push(
                                      '/solution-function-settings/$projectId');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.black),
                                onPressed: () {
                                  // Handle delete
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_outlined,
                                    color: Colors.black),
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
                                      vertical: 8, horizontal: 21),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                  minimumSize: const Size(0, 0),
                                ),
                                child: const Text(
                                  'Start',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 233, 234, 240),
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 8, right: 16, bottom: 16),
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
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: _isProgressExpanded
                                    ? Image.asset(
                                        "assets/images/icons/up-arrow.png",
                                        height: 6,
                                        width: 12,
                                      )
                                    : Image.asset(
                                        "assets/images/icons/down-arrow.png",
                                        height: 6,
                                        width: 12,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isProgressExpanded) ...[
                        const Divider(
                          color: Color.fromARGB(255, 233, 234, 240),
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const CheckProgressStatus(
                                  title: "Project Started", subtitle: "May 26"),
                              const CheckProgressStatus(
                                  title: "Feedback Requested John Davis",
                                  subtitle: "May 29"),
                              const CheckProgressStatus(
                                  title:
                                      "Feedback Received from Micheale David",
                                  subtitle: "May 29"),
                              const CheckProgressStatus(
                                  title: "Feedback Applied by John Davis",
                                  subtitle: "May 29"),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Image(
                                    image: AssetImage(
                                      "assets/images/icons/step.png",
                                    ),
                                    height: 20.4,
                                  ),
                                  const SizedBox(width: 7.93),
                                  Transform.translate(
                                    offset: const Offset(0, -5),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Error Corrected by John Davis",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13.6,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "May 29",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11.33,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 101, 103, 107),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                _buildDetailRow(
                  'Problem',
                  project.problemName ?? 'N/A',
                  Colors.red,
                  () {},
                ),
                _buildDetailRow(
                  'Solution',
                  project.solutionName ?? 'N/A',
                  const Color.fromARGB(255, 0, 161, 76),
                  () {},
                ),
                _buildDetailRow(
                  'Solution Function',
                  project.solutionFunctionName ?? 'N/A',
                  const Color.fromARGB(255, 0, 161, 76),
                  () {
                    final projectId = widget.projectId;
                    context.push('/solution-function/$projectId');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${project.completionPercentage ?? '0'}% Completed',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 0, 87, 255),
                              ),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(Routes.requestFeedback, extra: project);
                    },
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(
      String label, String value, Color valueColor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$label ',
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Removes all internal padding
                    alignment: Alignment.centerLeft,
                    minimumSize: Size.zero, // Ensures no extra size constraints
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: valueColor),
                    overflow: TextOverflow.clip,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(
            color: Color.fromARGB(255, 233, 234, 240),
            height: 0,
          ),
        ],
      ),
    );
  }
}
