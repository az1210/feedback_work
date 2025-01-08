import 'package:feedback_work/screens/feedback/widgets/preview_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/requested_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewFeedbackRequest extends StatelessWidget {
  const PreviewFeedbackRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: const Column(
        children: [
          PreviewFeedbackCard(),
        ],
      ),
    );
  }
}
