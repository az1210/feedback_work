import 'package:date_time_format/date_time_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/payment_dialogue.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FeedbackAppliedCard extends ConsumerStatefulWidget {
  const FeedbackAppliedCard({super.key, required this.feedback});

  final FeedbackModel feedback;

  @override
  ConsumerState<FeedbackAppliedCard> createState() =>
      _FeedbackAppliedCardState();
}

class _FeedbackAppliedCardState extends ConsumerState<FeedbackAppliedCard> {
  final quill.QuillController appliedMessageController =
      quill.QuillController.basic();
  FocusNode projectDescriptionFocusNode = FocusNode();

  String? selectedFilePath;

  bool isHelpful = false;

  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(currentUserProvider);
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
                  "Feedback Applied",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                ),
                Text(
                  DateTime.now().format('h:i A'),
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
                            "${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}",
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
                                  text: widget.feedback.project?.projectName,
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
                                  text: widget.feedback.project?.problemName,
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
                                  text: widget.feedback.project?.solutionName,
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
                                  text: widget
                                      .feedback.project!.solutionFunctionName,
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
                16.ph,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: context.colors.inputBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: quill.QuillToolbar.simple(
                          controller: appliedMessageController,
                          configurations: config,
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: context.colors.background,
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: quill.QuillEditor.basic(
                          controller: appliedMessageController,
                          focusNode: FocusNode(),

                          // padding: const EdgeInsets.all(16),
                          // autoFocus: true,
                          // showCursor: true,
                          // enableInteractiveSelection: true,
                        ),
                      ),
                    ],
                  ),
                ),
                16.ph,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: isHelpful,
                        onChanged: (val) {
                          setState(() {
                            isHelpful = val ?? false;
                          });
                        }),
                    const Expanded(
                        child: Text(
                            "Does the feedback help you solve the problem?")),
                  ],
                ),
                16.ph,
                Row(
                  children: [
                    Text(
                      "Attach File ",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                8.ph,
                InkWell(
                  onTap: pickFile,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashPattern: const [8, 8],
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, top: 12, bottom: 12),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/icons/cloud.png",
                              height: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedFilePath ?? 'Upload the file here',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 8, 102, 255)),
                            ),
                            const SizedBox(height: 4),
                            const Center(
                              child: Text(
                                '(Only .jpg, .png, & .pdf files will be accepted)',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                16.ph,
                Row(
                  children: [
                    Expanded(
                      child: AppButton.filled(
                        label: "Finish",
                        onTap: () {
                          final appliedModel = AppliedModel(
                            appliedMessage:
                                appliedMessageController.document.toDelta(),
                            appliedFile: selectedFilePath,
                            isHelpToSolve: isHelpful,
                          );
                          ref.read(feedbackProvider.notifier).appliedFeedback(
                                feedback: widget.feedback.copyWith(
                                  appliedFeedback: appliedModel,
                                ),
                                userId: currentUser!.id!,
                                callback: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PaymentDialogue(
                                      feedback: widget.feedback,
                                    ),
                                  );
                                },
                              );
                        },
                      ),
                    ),
                  ],
                ),
                16.ph,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
