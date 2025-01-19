import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class RequestedFeedbackCard extends StatefulWidget {
  final FeedbackModel feedback;
  final bool isGrid;

  const RequestedFeedbackCard({
    super.key,
    required this.feedback,
    required this.isGrid,
  });

  @override
  State<RequestedFeedbackCard> createState() => _RequestedFeedbackCardState();
}

class _RequestedFeedbackCardState extends State<RequestedFeedbackCard> {
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
                  "Feedback ${widget.feedback.feedbackStatus?.status}",
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
                              widget.feedback.feedbackStatus?.modifiedAt ??
                                  DateTime.now().toString())
                          .format("h:i A"),
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
                            "${widget.feedback.project?.owner?.firstName} ${widget.feedback.project?.owner?.lastName}",
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
                                  text: widget.feedback.project?.projectName ??
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
                                  text: widget.feedback.project?.problemName ??
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
                                  text: widget.feedback.project?.solutionName ??
                                      '',
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
                                  text: widget.feedback.project
                                          ?.solutionFunctionName ??
                                      '',
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
                    QuillEditor.basic(
                      controller: projectDescriptionController,
                      focusNode: projectDescriptionFocusNode,
                    ),
                    8.ph,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
