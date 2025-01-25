import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/received_feedback_details_card.dart';
import 'package:feedback_work/screens/feedback/widgets/received_feedback_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceivedFeedbackDetailsScreen extends StatefulWidget {
  const ReceivedFeedbackDetailsScreen({super.key, required this.feedbackModel});

  final FeedbackModel feedbackModel;
  @override
  _ReceivedFeedbackDetailsScreenState createState() =>
      _ReceivedFeedbackDetailsScreenState();
}

class _ReceivedFeedbackDetailsScreenState
    extends State<ReceivedFeedbackDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Feedback Details"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.ph,
                ReceivedFeedbackDetailsCard(
                  feedback: widget.feedbackModel,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
