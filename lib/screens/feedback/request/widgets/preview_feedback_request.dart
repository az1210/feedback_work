import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/screens/feedback/widgets/preview_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewFeedbackRequest extends StatelessWidget {
  const PreviewFeedbackRequest(
      {super.key, required this.feedback, required this.project});

  final FeedbackModel feedback;
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          PreviewFeedbackCard(
            feedbackModel: feedback,
            project: project,
          ),
        ],
      ),
    );
  }
}
