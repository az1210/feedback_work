import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/helper_functions.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/corrected_communication.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class ReceivedFeedbackCard extends StatefulWidget {
  final FeedbackModel feedback;
  final bool isGrid;
  final String currentUserId;

  const ReceivedFeedbackCard({
    super.key,
    required this.isGrid,
    required this.feedback,
    required this.currentUserId,
  });

  @override
  State<ReceivedFeedbackCard> createState() => _ReceivedFeedbackCardState();
}

class _ReceivedFeedbackCardState extends State<ReceivedFeedbackCard> {
  final QuillController projectDescriptionController = QuillController.basic();
  FocusNode projectDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    projectDescriptionController.document =
        Document.fromDelta(widget.feedback.project!.projectDescription!);
    projectDescriptionController.readOnly = true;
    projectDescriptionFocusNode.canRequestFocus = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.receivedFeedbackDetails,
            extra: widget.feedback);
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
                  if (widget.feedback.requestFeedback!.cost != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.colors.successGreen),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "\$${widget.feedback.requestFeedback!.cost}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              color: context.colors.successGreen,
                            ),
                      ),
                    ),
                  ],
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.parse(
                          "${widget.feedback.ownerSideStatus!.modifiedAt}",
                        ).format("h:i A"),
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
                    crossAxisCount: 3,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: widget.isGrid ? 3 : 1,
                        mainAxisCellCount: widget.isGrid ? 2.1 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: context.colors.background,
                              child: Image.network(
                                networkImage(
                                    widget.feedback.project?.owner?.avaterUrl),
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
                              "${widget.feedback.project?.owner?.firstName ?? ''} ${widget.feedback.project?.owner?.lastName ?? ''}",
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
                        crossAxisCellCount: widget.isGrid ? 3 : 2,
                        mainAxisCellCount: widget.isGrid ? 3 : 1.3,
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
                                  "${widget.feedback.project?.owner?.feedbackProvided ?? '0'}",
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
                                  "${widget.feedback.project?.owner?.feedbackApplied ?? '0'}",
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
                                  '${widget.feedback.project?.owner?.problemSolved ?? '0'}',
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
                                  '${widget.feedback.project?.owner?.problemHelpSolved ?? '0'}',
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
                      QuillEditor.basic(
                        controller: projectDescriptionController,
                        focusNode: projectDescriptionFocusNode,
                      ),
                      8.ph,
                      if (widget.isGrid) ...[
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.filled(
                                label: "Accept",
                                bgColor: context.colors.successGreen,
                                fgColor: context.colors.pureWhite,
                                onTap: () {
                                  context.pushNamed(Routes.applyFeedback,
                                      extra: widget.feedback);
                                },
                                verticalPadding: 8.h,
                              ),
                            ),
                          ],
                        ),
                        4.ph,
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.filled(
                                label: "Decline",
                                bgColor: context.colors.errorRed,
                                fgColor: context.colors.pureWhite,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        CorrectedCommunication(
                                      feedback: widget.feedback,
                                      userId: widget.currentUserId,
                                    ),
                                  );
                                },
                                verticalPadding: 8.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!widget.isGrid) ...[
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.filled(
                                label: "Accept",
                                bgColor: context.colors.successGreen,
                                fgColor: context.colors.pureWhite,
                                onTap: () {
                                  context.pushNamed(Routes.applyFeedback,
                                      extra: widget.feedback);
                                },
                                verticalPadding: 8.h,
                              ),
                            ),
                            4.pw,
                            Expanded(
                              child: AppButton.filled(
                                label: "Decline",
                                bgColor: context.colors.errorRed,
                                fgColor: context.colors.pureWhite,
                                onTap: () {},
                                verticalPadding: 8.h,
                              ),
                            ),
                          ],
                        )
                      ],
                      4.ph,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.filled(
                              label: "Apply",
                              bgColor: context.colors.primaryBlue,
                              fgColor: context.colors.pureWhite,
                              onTap: () {
                                context.pushNamed(Routes.applyFeedback,
                                    extra: widget.feedback);
                              },
                              verticalPadding: 8.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
