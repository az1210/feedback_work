import 'dart:convert';

import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PreviewFeedbackCard extends StatefulWidget {
  final FeedbackModel feedbackModel;
  final bool isGrid;

  const PreviewFeedbackCard({
    super.key,
    this.isGrid = false,
    required this.feedbackModel,
  });

  @override
  State<PreviewFeedbackCard> createState() => _PreviewFeedbackCardState();
}

class _PreviewFeedbackCardState extends State<PreviewFeedbackCard> {
  final quill.QuillController projectDescriptionController =
      quill.QuillController.basic();
  FocusNode projectDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    Log.info(widget.feedbackModel.project?.toMap().toString() ?? 'No Project');
    projectDescriptionController.document =
        widget.feedbackModel.requestFeedback!.message?.message != null
            ? quill.Document.fromDelta(
                widget.feedbackModel.requestFeedback!.message!.message!)
            : quill.Document.fromDelta(
                widget.feedbackModel.project!.projectDescription!);
    projectDescriptionController.readOnly = true;
    projectDescriptionFocusNode.canRequestFocus = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.pureWhite,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            color: context.colors.primaryBlue.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Feedback Requested",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                ),
                Text(
                  DateTime.parse(
                          widget.feedbackModel.providerSideStatus?.modifiedAt ??
                              DateTime.now().toString())
                      .format('h:i A'),
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
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
                            "${widget.feedbackModel.project?.owner?.firstName ?? ''} ${widget.feedbackModel.project?.owner?.lastName ?? ''}",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    16.pw,
                    Expanded(
                      flex: 2,
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
                                  text:
                                      widget.feedbackModel.project?.projectName,
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
                                  text:
                                      widget.feedbackModel.project?.problemName,
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
                                  text: widget
                                      .feedbackModel.project?.solutionName,
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
                                  text: widget.feedbackModel.project!
                                      .solutionFunctionName,
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
                if (widget.feedbackModel.requestFeedback!.message?.subject !=
                    null) ...[
                  16.ph,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.feedbackModel.requestFeedback!.message!.subject!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
                16.ph,
                quill.QuillEditor.basic(
                  controller: projectDescriptionController,
                  focusNode: projectDescriptionFocusNode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
