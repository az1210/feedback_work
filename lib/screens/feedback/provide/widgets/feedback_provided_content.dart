import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackProvidedContent extends StatefulWidget {
  const FeedbackProvidedContent({super.key});

  @override
  State<FeedbackProvidedContent> createState() =>
      _FeedbackProvidedContentState();
}

class _FeedbackProvidedContentState extends State<FeedbackProvidedContent> {
  final quill.QuillController feedbackMessageController =
      quill.QuillController.basic();
  String? selectedFilePath;

  bool isAnonymous = false;

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
                padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
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
      ],
    );
  }
}
