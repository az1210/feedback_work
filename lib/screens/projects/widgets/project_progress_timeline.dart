import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ProjectTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const ProjectTimeline({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      theme: TimelineThemeData(
        nodePosition: 0,
        connectorTheme: const ConnectorThemeData(
          thickness: 2.0,
          color: Colors.blue,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: events.length,
        contentsBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  events[index].title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateTime.parse(events[index].date).format("M d"),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return DotIndicator(
            size: 24,
            color: context.colors.primaryBlue,
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          );
        },
        connectorBuilder: (_, index, ___) => SolidLineConnector(
          color: context.colors.primaryBlue,
        ),
      ),
    );
  }
}

// Example usage:
class TimelineDemo extends StatelessWidget {
  TimelineDemo({super.key});

  final List<TimelineEvent> events = [
    const TimelineEvent(
      title: 'Project Started',
      date: 'May 26',
    ),
    const TimelineEvent(
      title: 'Feedback Requested by John Davis',
      date: 'May 29',
    ),
    const TimelineEvent(
      title: 'Feedback Received from Micheal David',
      date: 'May 29',
    ),
    const TimelineEvent(
      title: 'Feedback Applied by John Davis',
      date: 'May 29',
    ),
    const TimelineEvent(
      title: 'Error Corrected by John Davis',
      date: 'May 29',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectTimeline(events: events),
    );
  }
}
