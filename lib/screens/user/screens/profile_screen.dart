import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/network/widgets/stat_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() {
      final uid = ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';
      ref.read(fetchUserByIdProvider.notifier).fetchUser(uid: uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(fetchUserByIdProvider);
    ref.listen(fetchUserByIdProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        currentUser = newState.data;
      }
    });
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.editProfile, extra: currentUser);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (currentUser != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.pureWhite,
                        border: Border.all(
                          color: context.colors.darkGrey,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit_outlined,
                          color: context.colors.primaryBlue,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                8.ph,
                Text(
                  "${currentUser!.firstName} ${currentUser!.lastName}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  currentUser!.title != null && currentUser!.expertise != null
                      ? [currentUser!.title, currentUser!.expertise]
                          .where((e) => e != null)
                          .join(' • ')
                      : currentUser!.title != null
                          ? currentUser!.title!
                          : currentUser!.expertise != null
                              ? currentUser!.expertise!
                              : '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Minimum Feedback Price: ",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                        text: "\$${currentUser!.minimumRate}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                8.ph,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StaggeredGrid.count(
                          crossAxisCount: 6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1.5,
                              child: StatItemCard(
                                value:
                                    "\$${currentUser!.totalEarned == -1 ? 0 : currentUser!.totalEarned}",
                                label: "Total Earned",
                                valueColor: context.colors.successGreen,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1.5,
                              child: StatItemCard(
                                value:
                                    "\$${currentUser!.totalSpent == -1 ? 0 : currentUser!.totalSpent}",
                                label: "Total Spent",
                                valueColor: context.colors.errorRed,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.totalFeedbackProvidedForFree == -1 ? 0 : currentUser!.totalFeedbackProvidedForFree}",
                                label: "Total Feedback Provided for free",
                                valueColor: context.colors.successGreen,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.totalFeedbackAccepted == -1 ? 0 : currentUser!.totalFeedbackAccepted}",
                                label: "Total Feedback Accepted",
                                valueColor: context.colors.primaryBlue,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.totalSpent == -1 ? 0 : currentUser!.totalSpent}",
                                label: "Total Feedback Declined",
                                valueColor: context.colors.errorRed,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.feedbackApplied == -1 ? 0 : currentUser!.feedbackApplied}",
                                label: "Total Feedback Applied",
                                valueColor: context.colors.primaryBlue,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.problemSolved == -1 ? 0 : currentUser!.problemSolved}",
                                label: "Total Problems Solved",
                                valueColor: context.colors.successGreen,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2.5,
                              child: StatItemCard(
                                value:
                                    "${currentUser!.problemHelpSolved == -1 ? 0 : currentUser!.problemHelpSolved}",
                                label: "Total Problems Help Solved",
                                valueColor: context.colors.successGreen,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 6,
                              mainAxisCellCount: 1.5,
                              child: StatItemCard(
                                //TODO: Should be calculated
                                value: "0",
                                label: "Total",
                                valueColor: context.colors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        16.ph,
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.filled(
                                label: "View Transaction History",
                                fgColor: context.colors.primaryBlue,
                                bgColor: context.colors.primaryBlue
                                    .withValues(alpha: 0.1),
                                width: double.infinity,
                                onTap: () {
                                  context.pushNamed(Routes.transactionHistory);
                                },
                              ),
                            ),
                          ],
                        ),
                        16.ph,
                        Row(
                          children: [
                            const Icon(Icons.lock),
                            4.pw,
                            const Text("Feedback with connection only"),
                          ],
                        ),
                        32.ph,
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
