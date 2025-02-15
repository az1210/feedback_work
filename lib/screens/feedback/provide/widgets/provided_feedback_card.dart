import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/feedback_provided_content.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/model2_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;

class ProvidedFeedbackCard extends ConsumerStatefulWidget {
  const ProvidedFeedbackCard(
      {required this.feedbackMessageController,
      required this.onSelectedFilePath,
      required this.feedback,
      super.key});

  final FeedbackModel feedback;
  final quill.QuillController feedbackMessageController;
  final void Function(String) onSelectedFilePath;

  @override
  ConsumerState<ProvidedFeedbackCard> createState() =>
      _ProvidedFeedbackCardState();
}

class _ProvidedFeedbackCardState extends ConsumerState<ProvidedFeedbackCard> {
  Future<String> uploadFileToFirebase(String filePath) async {
    final fileName = filePath.split('/').last; // Extract the file name
    final firebaseStorage = ref.read(storageProvider);
    final storageRef = firebaseStorage.ref().child(
        'project_images/$fileName'); // Create a reference in Firebase Storage

    final file = File(filePath); // Local file reference

    await storageRef.putFile(file);

    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    const config = quill.QuillSimpleToolbarConfigurations(
      multiRowsDisplay: true,
      showFontFamily: true,
      showFontSize: true,
      showBoldButton: true,
      showItalicButton: true,
      showUnderLineButton: true,
      showStrikeThrough: true,
      showColorButton: true,
      showAlignmentButtons: true,
      showSubscript: true,
      showSuperscript: true,
      showLink: true,
    );
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
                                '${widget.feedback.project?.owner?.problemSolved == -1 ? '0' : widget.feedback.project?.owner?.problemSolved}',
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
                                '${widget.feedback.project?.owner?.problemHelpSolved == -1 ? '0' : widget.feedback.project?.owner?.problemHelpSolved}',
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
                FeedbackProvidedContent(
                  feedbackMessageController: widget.feedbackMessageController,
                  onSelectedFilePath: widget.onSelectedFilePath,
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
        ],
      ),
    );
  }
}
