import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/helper_functions.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:feedback_work/screens/feedback/widgets/received_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/requested_feedback_card.dart';
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
  @override
  Widget build(BuildContext context) {
    return feedbackStatus(
                feedback: widget.feedback, userId: widget.currentUserId) ==
            FeedbackScreenConnectionType.received.name.toTitleCase()
        ? ReceivedFeedbackCard(
            isGrid: widget.isGrid,
            feedback: widget.feedback,
            currentUserId: widget.currentUserId,
          )
        : feedbackStatus(
                    feedback: widget.feedback, userId: widget.currentUserId) ==
                FeedbackScreenConnectionType.requested.name.toTitleCase()
            ? RequestedFeedbackCard(
                isGrid: widget.isGrid,
                feedback: widget.feedback,
                currentUserId: widget.currentUserId,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                                      backgroundColor:
                                          context.colors.background,
                                      child: Image.network(
                                        networkImage(widget.feedback.project
                                            ?.owner?.avaterUrl),
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
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
                                        style:
                                            DefaultTextStyle.of(context).style,
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
                                                  color:
                                                      context.colors.errorRed,
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
                                        style:
                                            DefaultTextStyle.of(context).style,
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
                                                  color: context
                                                      .colors.successGreen,
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
                                        style:
                                            DefaultTextStyle.of(context).style,
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
                                                  color: context
                                                      .colors.successGreen,
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
                              // QuillEditor.basic(
                              //   controller: projectDescriptionController,
                              //   focusNode: projectDescriptionFocusNode,
                              // ),
                              8.ph,
                              if (feedbackStatus(
                                          feedback: widget.feedback,
                                          userId: widget.currentUserId) ==
                                      FeedbackScreenConnectionType
                                          .requested.name
                                          .toTitleCase() &&
                                  widget.feedback.ownerId ==
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
                                      FeedbackScreenConnectionType
                                          .requested.name
                                          .toTitleCase() &&
                                  widget.feedback.providerId ==
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
