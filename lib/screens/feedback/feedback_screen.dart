import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/screens/feedback/widgets/received_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/requested_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool isGrid = true;

  FeedbackScreenConnectionType feedbackScreenConnectionType =
      FeedbackScreenConnectionType.all;

  List<FeedbackModel> feedbacks = [];
  List<FeedbackModel> filteredFeedbacks = [];

  @override
  void initState() {
    Future.microtask(() {
      final auth = ref.read(firebaseAuthProvider);
      ref
          .read(feedbackProvider.notifier)
          .fetchAllFeedbacks(userId: auth.currentUser!.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);
    ref.listen(feedbackProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        feedbacks = newState.data!;
        Log.info(feedbacks
            .map((f) => Text(f.id ?? "Id Unknown"))
            .toList()
            .toString());
      }
    });
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
      body: Builder(builder: (context) {
        if (feedbackState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (feedbackState.error != null) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          filteredFeedbacks = feedbackScreenConnectionType ==
                  FeedbackScreenConnectionType.all
              ? feedbacks
              : feedbackScreenConnectionType ==
                      FeedbackScreenConnectionType.requested
                  ? feedbacks
                      .where((f) =>
                          f.feedbackStatus!.last.status! ==
                          FeedbackStatus.requested.toString().toTitleCase())
                      .toList()
                  : feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.received
                      ? feedbacks
                          .where((f) =>
                              f.feedbackStatus!.last.status! ==
                              FeedbackStatus.received.toString().toTitleCase())
                          .toList()
                      : feedbackScreenConnectionType ==
                              FeedbackScreenConnectionType.applied
                          ? feedbacks
                              .where((f) =>
                                  f.feedbackStatus!.last.status! ==
                                  FeedbackStatus.applied
                                      .toString()
                                      .toTitleCase())
                              .toList()
                          : feedbacks;
          return Column(
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
                      MasonryGridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredFeedbacks.length,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isGrid ? 2 : 1),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.all(8.r),
                          child: RequestedFeedbackCard(
                            isGrid: isGrid,
                            feedback: filteredFeedbacks[index],
                          ),
                        ),
                      ),
                      // if (feedbackScreenConnectionType ==
                      //         FeedbackScreenConnectionType.received ||
                      //     feedbackScreenConnectionType ==
                      //         FeedbackScreenConnectionType.all)
                      //   MasonryGridView.builder(
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: 4,
                      //     gridDelegate:
                      //         SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: isGrid ? 2 : 1),
                      //     itemBuilder: (context, index) => Padding(
                      //       padding: EdgeInsets.all(8.r),
                      //       child: ReceivedFeedbackCard(
                      //         isGrid: isGrid,
                      //         username: 'Janet Rose',
                      //         totalFeedbackProvided: 20,
                      //         totalFeedbackApplied: 10,
                      //         totalProblemSolved: 5,
                      //         totalProblemHelpSolved: 10,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
