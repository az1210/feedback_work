import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RequestedFeedbackCard extends StatelessWidget {
  final String userName;
  final String project;
  final String problem;
  final String solution;
  final String solutionFunction;
  final String description;
  final bool isGrid;

  const RequestedFeedbackCard({
    super.key,
    this.isGrid = false,
    this.userName = "John Thompson",
    this.project = "Floor Cleaning",
    this.problem = "Dirty Floor",
    this.solution = "Clean Floor",
    this.solutionFunction = "Mop Floor",
    this.description = "Need help floor cleaning hard surface",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  "Feedback Requested",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "02:42 PM",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      " • ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Icon(
                      Icons.lock_outline,
                      size: 16.r,
                    ),
                  ],
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
                      mainAxisCellCount: isGrid ? 0.7 : 1.2,
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
                            userName,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: isGrid ? 1 : 2,
                      mainAxisCellCount: isGrid ? 1 : 1.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Project ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                TextSpan(
                                  text: project,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            color: context.colors.inputBorder,
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Problem ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                TextSpan(
                                  text: problem,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: context.colors.errorRed,
                                      ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            color: context.colors.inputBorder,
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Solution ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                TextSpan(
                                  text: solution,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: context.colors.successGreen,
                                      ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            color: context.colors.inputBorder,
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Solution Function ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                TextSpan(
                                  text: solutionFunction,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: context.colors.successGreen,
                                      ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                      label: "Send Feedback",
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
    );
  }
}
