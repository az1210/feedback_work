import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/providers/supabase_providers.dart';
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
  FeedbackScreenConnectionType feedbackScreenConnectionType =
      FeedbackScreenConnectionType.all;

  List<FeedbackModel> allFeedbacks = [];
  List<FeedbackModel> ownFeedbacks = [];
  List<FeedbackModel> anotherFeedbacks = [];
  List<FeedbackModel> filteredFeedbacks = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Stripe.publishableKey =
          await ref.read(paymentProvider.notifier).stripePublishableKey() ?? '';
      final auth = ref.read(supabaseAuthProvider);
      await ref.read(userProvider.notifier).currentUser();
      await ref
          .read(feedbackProvider.notifier)
          .fetchAllFeedbacks(userId: auth.currentUser!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FeedbackNotifierState>(feedbackProvider, (previous, next) {
      if (next.state == AsyncState.success) {
        setState(() {
          allFeedbacks = next.allFeedback ?? [];
          final currentUser = ref.read(currentUserProvider);
          if (currentUser != null) {
            ownFeedbacks =
                allFeedbacks.where((f) => f.ownerId == currentUser.id).toList();
            anotherFeedbacks = allFeedbacks
                .where((f) => f.providerId == currentUser.id)
                .toList();
          }
        });
      }
    });

    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // final feedbackState = ref.watch(feedbackProvider);

    // Filter feedbacks based on selected connection type.
    if (feedbackScreenConnectionType == FeedbackScreenConnectionType.all) {
      filteredFeedbacks = allFeedbacks;
    } else if (feedbackScreenConnectionType ==
        FeedbackScreenConnectionType.requested) {
      filteredFeedbacks = allFeedbacks
          .where((f) =>
              f.ownerSideStatus!.status ==
                  FeedbackStatus.requested.name.toTitleCase() &&
              f.providerSideStatus!.status ==
                  FeedbackStatus.requested.name.toTitleCase())
          .toList();
    } else if (feedbackScreenConnectionType ==
        FeedbackScreenConnectionType.received) {
      filteredFeedbacks = ownFeedbacks
          .where((f) =>
              f.ownerSideStatus!.status ==
              FeedbackStatus.received.name.toTitleCase())
          .toList();
    } else if (feedbackScreenConnectionType ==
        FeedbackScreenConnectionType.applied) {
      filteredFeedbacks = ownFeedbacks
          .where((f) =>
              f.ownerSideStatus!.status ==
              FeedbackStatus.applied.name.toTitleCase())
          .toList();
    } else if (feedbackScreenConnectionType ==
        FeedbackScreenConnectionType.provided) {
      filteredFeedbacks = anotherFeedbacks
          .where((f) =>
              f.providerSideStatus!.status ==
              FeedbackStatus.provided.name.toTitleCase())
          .toList();
    } else {
      filteredFeedbacks = allFeedbacks;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_view),
          ),
        ],
      ),
      body: Column(
        children: [
          FeedbackSearchAndFilter(
            onChangedConnectionState: (newType) {
              setState(() {
                feedbackScreenConnectionType = newType;
              });
            },
          ),
          8.ph,
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final auth = ref.read(supabaseAuthProvider);
                await ref
                    .read(feedbackProvider.notifier)
                    .fetchAllFeedbacks(userId: auth.currentUser!.id);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          currentUserId: currentUser.id ?? '',
                          isMine:
                              ownFeedbacks.contains(filteredFeedbacks[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
