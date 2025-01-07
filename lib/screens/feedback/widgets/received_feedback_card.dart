import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class ReceivedFeedbackCard extends StatelessWidget {
  final String username;
  final int totalFeedbackProvided;
  final int totalFeedbackApplied;
  final int totalProblemSolved;
  final int totalProblemHelpSolved;
  final String description;
  final bool isGrid;

  const ReceivedFeedbackCard({
    super.key,
    required this.isGrid,
    this.description = "Need help floor cleaning hard surface",
    required this.username,
    required this.totalFeedbackProvided,
    required this.totalFeedbackApplied,
    required this.totalProblemSolved,
    required this.totalProblemHelpSolved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.receivedFeedbackDetails);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 8.h,
              ),
              color: context.colors.primaryBlue.withValues(alpha: 0.1),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    "Feedback Received",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  Text(
                    "02:42 PM",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  16.ph,
                  StaggeredGrid.count(
                    crossAxisCount: isGrid ? 1 : 3,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: isGrid ? 0.7 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: context.colors.background,
                              child: Image.network(
                                '',
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.person,
                                  color: context.colors.darkGrey,
                                  size: 30.r,
                                ),
                              ),
                            ),
                            8.ph,
                            Text(
                              username,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: isGrid ? 1 : 2,
                        mainAxisCellCount: isGrid ? 0.9 : 1.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Feedback Provided",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  totalFeedbackProvided.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: context.colors.primaryBlue,
                                      ),
                                ),
                              ],
                            ),
                            Divider(
                              color: context.colors.inputBorder,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Feedback Applied",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  totalFeedbackApplied.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: context.colors.primaryBlue,
                                      ),
                                ),
                              ],
                            ),
                            Divider(
                              color: context.colors.inputBorder,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Problem Solved",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  totalProblemSolved.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: context.colors.successGreen,
                                      ),
                                ),
                              ],
                            ),
                            Divider(
                              color: context.colors.inputBorder,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Problems Help Solved",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  totalProblemHelpSolved.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: context.colors.successGreen,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      8.ph,
                      AppButton(
                        label: "Apply Feedback",
                        bgColor: context.colors.primaryBlue,
                        fgColor: context.colors.pureWhite,
                        isFilled: true,
                        verticalPadding: 8.h,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
