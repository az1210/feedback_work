import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModelTwoContent extends StatefulWidget {
  const ModelTwoContent({super.key, required this.feedback});

  final FeedbackModel feedback;

  @override
  State<ModelTwoContent> createState() => _ModelTwoContentState();
}

class _ModelTwoContentState extends State<ModelTwoContent> {
  final quill.QuillController feedbackMessageController =
      quill.QuillController.basic();
  String? selectedOption;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        16.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.feedback.provideFeedback?.principle ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        16.ph,
        Expanded(
          child: ListView.builder(
            itemCount: widget
                    .feedback.provideFeedback?.principleToDeriveFrom?.length ??
                0,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  // widget.onSelectModel(widget.feedback.provideFeedback?.principleToDeriveFrom?[index]);
                  selectedOption = widget
                      .feedback.provideFeedback?.principleToDeriveFrom?[index];
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                    color: selectedOption ==
                            widget.feedback.provideFeedback
                                ?.principleToDeriveFrom?[index]
                        ? context.colors.primaryBlue.withValues(alpha: 0.1)
                        : context.colors.pureWhite),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "${index + 1}. ${widget.feedback.provideFeedback?.principleToDeriveFrom?[index]}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: selectedOption ==
                                    widget.feedback.provideFeedback
                                        ?.principleToDeriveFrom?[index]
                                ? context.colors.primaryBlue
                                : context.colors.textBlack,
                          ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "Feedback Message",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 5),
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
                  controller: feedbackMessageController,
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
                  controller: feedbackMessageController,
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
      ],
    );
  }
}
