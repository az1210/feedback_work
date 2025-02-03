import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool isGrid = true;

  UserModel? currentUser;

  FeedbackScreenConnectionType feedbackScreenConnectionType =
      FeedbackScreenConnectionType.all;

  List<FeedbackModel> allFeedbacks = [];
  List<FeedbackModel> ownFeedbacks = [];
  List<FeedbackModel> anotherFeedbacks = [];
  List<FeedbackModel> filteredFeedbacks = [];

  @override
  void initState() {
    Future.microtask(() async {
      Stripe.publishableKey =
          await ref.watch(paymentProvider.notifier).stripePublishableKey() ??
              '';
      final auth = ref.read(firebaseAuthProvider);
      currentUser = await ref.watch(userProvider.notifier).currentUser();
      ref
          .read(feedbackProvider.notifier)
          .fetchAllFeedbacks(userId: auth.currentUser!.uid);
      // await ref
      //     .read(feedbackProvider.notifier)
      //     .fetchAllFeedbacksAsProvider(userId: currentUser!.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);
    ref.listen(feedbackProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        allFeedbacks = newState.allFeedback ?? [];
        Log.info(ownFeedbacks
            .map(
                (f) => f.requestFeedback!.selectedGroupMemberIds!.map((p) => p))
            .toList()
            .toString());
        ownFeedbacks =
            allFeedbacks.where((f) => f.ownerId == currentUser!.id).toList();
        anotherFeedbacks =
            allFeedbacks.where((f) => f.providerId == currentUser!.id).toList();
      }
    });
    Log.info(anotherFeedbacks.length.toString());
    Log.info(ownFeedbacks.length.toString());

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
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // ref
              //     .read(feedbackProvider.notifier)
              //     .deleteCollection(FirebaseConstants.apiKeyCollection);
              // ref.read(paymentProvider.notifier).stripePublishableKey();
              // ref.read(paymentProvider.notifier).stripeSecretKey();

              // ref.read(feedbackProvider.notifier).deleteSubCollection(
              //     collectionPath: FirebaseConstants.userCollection,
              //     docId: currentUser!.id,
              //     subCollectionPath: FirebaseConstants.feedbackCollection);
            },
          ),
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
              ? allFeedbacks
              : feedbackScreenConnectionType ==
                      FeedbackScreenConnectionType.requested
                  ? allFeedbacks
                      .where((f) =>
                          f.ownerSideStatus!.status ==
                              FeedbackStatus.requested.name.toTitleCase() ||
                          f.providerSideStatus!.status ==
                              FeedbackStatus.requested.name.toTitleCase())
                      .toList()
                  // : feedbackScreenConnectionType ==
                  //         FeedbackScreenConnectionType.providing
                  //     ? anotherFeedbacks
                  //         .where((f) =>
                  //             f.providerSideStatus!.status ==
                  //             FeedbackStatus.providing.name.toTitleCase())
                  //         .toList()
                  : feedbackScreenConnectionType ==
                          FeedbackScreenConnectionType.received
                      ? ownFeedbacks
                          .where((f) =>
                              f.ownerSideStatus!.status ==
                              FeedbackStatus.received.name.toTitleCase())
                          .toList()
                      : feedbackScreenConnectionType ==
                              FeedbackScreenConnectionType.applied
                          ? ownFeedbacks
                              .where((f) =>
                                  f.ownerSideStatus!.status ==
                                  FeedbackStatus.applied.name.toTitleCase())
                              .toList()
                          : feedbackScreenConnectionType ==
                                  FeedbackScreenConnectionType.provided
                              ? anotherFeedbacks
                                  .where((f) =>
                                      f.providerSideStatus!.status ==
                                      FeedbackStatus.provided.name
                                          .toTitleCase())
                                  .toList()
                              : allFeedbacks;
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
                          child: FeedbackCard(
                            isGrid: isGrid,
                            feedback: filteredFeedbacks[index],
                            currentUserId: currentUser?.id ?? '',
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
