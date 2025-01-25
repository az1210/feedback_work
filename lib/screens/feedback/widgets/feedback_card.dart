import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/helper_functions.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class FeedbackCard extends ConsumerStatefulWidget {
  final FeedbackModel feedback;
  final bool isGrid;
  final String currentUserId;

  const FeedbackCard({
    super.key,
    required this.feedback,
    required this.isGrid,
    required this.currentUserId,
  });

  @override
  ConsumerState<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends ConsumerState<FeedbackCard> {
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
    return feedbackStatus(
                feedback: widget.feedback, userId: widget.currentUserId) ==
            FeedbackScreenConnectionType.received.name.toTitleCase()
        ? GestureDetector(
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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                        if (widget.feedback.requestFeedback!.cost != -1) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.r),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: context.colors.successGreen),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "\$${widget.feedback.requestFeedback!.cost}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
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
                                "${feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.requested.name.toTitleCase() && isOwnRequestedFeedback(feedback: widget.feedback, userId: widget.currentUserId) ? widget.feedback.ownerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.requested.name.toTitleCase() && isOwnRequestedFeedback(feedback: widget.feedback, userId: widget.currentUserId) ? widget.feedback.providerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.providing.name.toTitleCase() ? widget.feedback.providerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.received.name.toTitleCase() ? widget.feedback.ownerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.applied.name.toTitleCase() ? widget.feedback.ownerSideStatus!.modifiedAt : widget.feedback.providerSideStatus!.modifiedAt}",
                              ).format("h:i A"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            Text(
                              " • ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                      '',
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        "${widget.feedback.project?.owner?.feedbackProvided == -1 ? '0' : widget.feedback.project?.owner?.feedbackProvided}",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        "${widget.feedback.project?.owner?.feedbackApplied == -1 ? '0' : widget.feedback.project?.owner?.feedbackApplied}",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        '${widget.feedback.project?.owner?.problemSolved == -1 ? '0' : widget.feedback.project?.owner?.problemSolved}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color:
                                                  context.colors.successGreen,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: context.colors.inputBorder,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        '${widget.feedback.project?.owner?.problemHelpSolved == -1 ? '0' : widget.feedback.project?.owner?.problemHelpSolved}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color:
                                                  context.colors.successGreen,
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
                                      onTap: () {},
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
          )
        : Card(
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
                        "Feedback ${feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId)}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateTime.parse(
                              "${feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.requested.name.toTitleCase() && isOwnRequestedFeedback(feedback: widget.feedback, userId: widget.currentUserId) ? widget.feedback.ownerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.requested.name.toTitleCase() && isOwnRequestedFeedback(feedback: widget.feedback, userId: widget.currentUserId) ? widget.feedback.providerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.providing.name.toTitleCase() ? widget.feedback.providerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.received.name.toTitleCase() ? widget.feedback.ownerSideStatus!.modifiedAt : feedbackStatus(feedback: widget.feedback, userId: widget.currentUserId) == FeedbackScreenConnectionType.applied.name.toTitleCase() ? widget.feedback.ownerSideStatus!.modifiedAt : widget.feedback.providerSideStatus!.modifiedAt}",
                            ).format("h:i A"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            " • ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                        crossAxisCount: widget.isGrid ? 1 : 3,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: widget.isGrid ? 0.7 : 1.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: context.colors.background,
                                  child: Image.network(
                                    '',
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      color: context.colors.darkGrey,
                                      size: 30.r,
                                    ),
                                  ),
                                ),
                                8.ph,
                                Text(
                                  "${widget.feedback.project?.owner?.firstName} ${widget.feedback.project?.owner?.lastName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
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
                            crossAxisCellCount: widget.isGrid ? 1 : 2,
                            mainAxisCellCount: widget.isGrid ? 1 : 1.2,
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
                                        text: widget.feedback.project
                                                ?.projectName ??
                                            '',
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
                                        text: widget.feedback.project
                                                ?.problemName ??
                                            '',
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
                                        text: widget.feedback.project
                                                ?.solutionName ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  context.colors.successGreen,
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
                                        text: widget.feedback.project
                                                ?.solutionFunctionName ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color:
                                                  context.colors.successGreen,
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
                          QuillEditor.basic(
                            controller: projectDescriptionController,
                            focusNode: projectDescriptionFocusNode,
                          ),
                          8.ph,
                          if (feedbackStatus(
                                      feedback: widget.feedback,
                                      userId: widget.currentUserId) ==
                                  FeedbackScreenConnectionType.requested.name
                                      .toTitleCase() &&
                              widget.feedback.projectOwnerId ==
                                  widget.currentUserId) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton.filled(
                                    label: "Send Feedback",
                                    bgColor: context.colors.primaryBlue,
                                    fgColor: context.colors.pureWhite,
                                    onTap: () {
                                      context.pushNamed(
                                        Routes.provideFeedback,
                                        extra: widget.feedback,
                                      );
                                    },
                                    verticalPadding: 8.h,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (feedbackStatus(
                                      feedback: widget.feedback,
                                      userId: widget.currentUserId) ==
                                  FeedbackScreenConnectionType.requested.name
                                      .toTitleCase() &&
                              widget.feedback.requestFeedback!.provider ==
                                  widget.currentUserId) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton.filled(
                                    label: "Provide Feedback",
                                    bgColor: context.colors.primaryBlue,
                                    fgColor: context.colors.pureWhite,
                                    onTap: () {
                                      context.pushNamed(
                                        Routes.provideFeedback,
                                        extra: widget.feedback,
                                      );
                                    },
                                    verticalPadding: 8.h,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
