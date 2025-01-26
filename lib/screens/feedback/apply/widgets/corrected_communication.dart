import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CorrectedCommunication extends StatefulWidget {
  const CorrectedCommunication({super.key});

  @override
  _CorrectedCommunicationState createState() => _CorrectedCommunicationState();
}

class _CorrectedCommunicationState extends State<CorrectedCommunication> {
  final quill.QuillController appliedMessageController =
      quill.QuillController.basic();
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
        Text(
          "Corrected Communication",
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
        Row(
          children: [
            Expanded(
              child: AppButton.outlined(
                label: 'Cancel',
                onTap: () {
                  context.pop();
                },
              ),
            ),
            Expanded(
              child: AppButton.filled(
                label: 'Save',
                onTap: () {},
              ),
            ),
          ],
        )
      ],
    );
  }
}
