import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/provided_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/preview_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PreviewSetScreen extends ConsumerStatefulWidget {
  const PreviewSetScreen({
    this.onChangeAnnonymous,
    super.key,
    required this.feedback,
  });

  final FeedbackModel feedback;
  final void Function(bool)? onChangeAnnonymous;

  @override
  ConsumerState<PreviewSetScreen> createState() => _PreviewSetScreenState();
}

class _PreviewSetScreenState extends ConsumerState<PreviewSetScreen> {
  bool isAnnonymous = false;
  UserModel? currentUser;
  final quill.QuillController feedbackMessageController =
      quill.QuillController.basic();
  String? selectedFilePath;

  @override
  void initState() {
    Future.microtask(() async {
      currentUser = await ref.watch(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          context.goNamed(Routes.feedback);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Provide Feedback"),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  16.ph,
                  PreviewFeedbackCard(
                    feedbackModel: widget.feedback,
                  ),
                  16.ph,
                  ProvidedFeedbackCard(
                    feedback: widget.feedback,
                    feedbackMessageController: feedbackMessageController,
                    onSelectedFilePath: (p0) {
                      setState(() {
                        selectedFilePath = p0;
                      });
                    },
                  ),
                  16.ph,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.pureWhite,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: context.colors.inputBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Send feedback annonymously",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 15,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Switch(
                            value: isAnnonymous,
                            onChanged: (val) {
                              setState(() {
                                isAnnonymous = val;
                                widget.onChangeAnnonymous!(val);
                              });
                            })
                      ],
                    ),
                  ),
                  16.ph,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.filled(
                          label: "Provide Feedback",
                          bgColor: context.colors.primaryBlue,
                          fgColor: context.colors.pureWhite,
                          onTap: () {
                            ref.read(feedbackProvider.notifier).provideFeedback(
                                  feedbackId: widget.feedback.id!,
                                  projectId: widget.feedback.project!.id!,
                                  provideFeedback:
                                      widget.feedback.provideFeedback!.copyWith(
                                    feedbackMessage: feedbackMessageController
                                        .document
                                        .toDelta(),
                                    annonymous: isAnnonymous,
                                    feedbackFile: selectedFilePath,
                                  ),
                                  user: currentUser!,
                                  callback: () {
                                    context.goNamed(Routes.feedback);
                                  },
                                );
                          },
                          verticalPadding: 8.h,
                        ),
                      ),
                    ],
                  ),
                  16.ph,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
