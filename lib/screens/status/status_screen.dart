import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/status/widgets/project_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  final formKey = GlobalKey<FormState>();
  bool isGrid = true;
  List<FeedbackModel> allFeedbacks = [];
  List<FeedbackModel> ownFeedbacks = [];
  List<FeedbackModel> anotherFeedbacks = [];
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() async {
      currentUser = await ref.watch(userProvider.notifier).currentUser();
      ref
          .read(feedbackProvider.notifier)
          .fetchAllFeedbacks(userId: currentUser!.id!);
      //   await ref
      //       .read(feedbackProvider.notifier)
      //       .fetchAllFeedbacksAsProvider(userId: currentUser!.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);
    ref.listen(feedbackProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        allFeedbacks = newState.allFeedback!;
        ownFeedbacks =
            allFeedbacks.where((f) => f.ownerId == currentUser!.id).toList();
        anotherFeedbacks =
            allFeedbacks.where((f) => f.providerId == currentUser!.id).toList();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Status",
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allFeedbacks.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isGrid ? 2 : 1),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          Routes.statusReport,
                          extra: allFeedbacks[index],
                        );
                      },
                      child: ProjectStatusCard(
                        feedback: allFeedbacks[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
