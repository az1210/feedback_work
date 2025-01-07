import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/screens/feedback/widgets/received_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/requested_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool isGrid = true;

  FeedbackScreenConnectionType feedbackScreenConnectionType =
      FeedbackScreenConnectionType.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid
                ? const Icon(
                    Icons.list,
                  )
                : const Icon(
                    Icons.grid_view,
                  ),
          ),
          8.pw,
        ],
      ),
      body: Column(
        children: [
          FeedbackSearchAndFilter(
            onChangedConnectionState: (p0) {
              setState(() {
                feedbackScreenConnectionType = p0;
              });
            },
          ),
          8.ph,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.requested ||
                      feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.all)
                    MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isGrid ? 2 : 1),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(8.r),
                        child: RequestedFeedbackCard(
                          isGrid: isGrid,
                        ),
                      ),
                    ),
                  if (feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.received ||
                      feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.all)
                    MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isGrid ? 2 : 1),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(8.r),
                        child: ReceivedFeedbackCard(
                          isGrid: isGrid,
                          username: 'Janet Rose',
                          totalFeedbackProvided: 20,
                          totalFeedbackApplied: 10,
                          totalProblemSolved: 5,
                          totalProblemHelpSolved: 10,
                        ),
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
}
