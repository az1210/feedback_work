import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/provided_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/preview_feedback_card.dart';
import 'package:feedback_work/screens/feedback/widgets/received_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewSetScreen extends ConsumerStatefulWidget {
  const PreviewSetScreen({super.key, required this.feedback});

  final FeedbackModel feedback;

  @override
  ConsumerState<PreviewSetScreen> createState() => _PreviewSetScreenState();
}

class _PreviewSetScreenState extends ConsumerState<PreviewSetScreen> {
  bool isAnnonymous = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
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
                              // widget.onChangeAnnonymous!(val);
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
                          final fb = widget.feedback.copyWith(
                            feedbackStatus: Status(
                              status:
                                  FeedbackStatus.provided.name.toTitleCase(),
                              modifiedAt: DateTime.now().toString(),
                            ),
                          );

                          Log.info(fb.feedbackStatus!.toMap().toString());
                          ref.read(feedbackProvider.notifier).provideFeedback(
                                feedback: fb,
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
    );
  }
}
