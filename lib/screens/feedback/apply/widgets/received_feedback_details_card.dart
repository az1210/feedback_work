import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/corrected_communication.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/provided_content.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/model2_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';

class ReceivedFeedbackDetailsCard extends ConsumerStatefulWidget {
  const ReceivedFeedbackDetailsCard({required this.feedback, super.key});

  final FeedbackModel feedback;

  @override
  ConsumerState<ReceivedFeedbackDetailsCard> createState() =>
      _ProvidedFeedbackCardState();
}

class _ProvidedFeedbackCardState
    extends ConsumerState<ReceivedFeedbackDetailsCard> {
  quill.QuillController feedbackMessageController =
      quill.QuillController.basic();

  String? selectedPath;

  @override
  void initState() {
    if (widget.feedback.provideFeedback != null) {
      if (widget.feedback.provideFeedback!.feedbackMessage != null) {
        feedbackMessageController.document = quill.Document.fromDelta(
            widget.feedback.provideFeedback!.feedbackMessage!);
      }
    }

    feedbackMessageController.readOnly = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: context.colors.pureWhite,
      ),
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
                  "Feedback Provided",
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
                Text(
                  DateTime.now().format("h:i A"),
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
                  crossAxisCount: 3,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: context.colors.background,
                            child: Image.network(
                              networkImage(
                                  widget.feedback.project?.owner?.avatarUrl),
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
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1.3,
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const TabBar(
              tabs: [
                Tab(
                  text: "Feedback",
                ),
                Tab(
                  text: "Model1",
                ),
                Tab(
                  text: "Model2",
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 500.h,
            width: 0.9.sw,
            child: TabBarView(
              children: [
                ProvidedContent(
                  feedbackMessage:
                      widget.feedback.provideFeedback!.feedbackMessage!,
                  onSelectedFilePath: (p0) {
                    setState(() {
                      selectedPath = p0;
                    });
                  },
                ),
                Column(
                  children: [
                    32.ph,
                    Image.asset(AppAssets.images.ecf),
                  ],
                ),
                ModelTwoContent(
                  feedback: widget.feedback,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
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
                8.pw,
                Expanded(
                  child: AppButton.filled(
                    label: "Decline",
                    bgColor: context.colors.errorRed,
                    fgColor: context.colors.pureWhite,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CorrectedCommunication(
                          feedback: widget.feedback,
                          userId: widget.feedback.ownerId!,
                        ),
                      );
                    },
                    verticalPadding: 8.h,
                  ),
                ),
                8.pw,
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
          ),
          16.ph,
        ],
      ),
    );
  }
}
