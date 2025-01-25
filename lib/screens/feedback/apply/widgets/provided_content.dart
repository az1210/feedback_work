import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/file_upload_helper.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProvidedContent extends StatefulWidget {
  const ProvidedContent({
    super.key,
    required this.feedbackMessage,
    required this.onSelectedFilePath,
  });

  final Delta feedbackMessage;
  final void Function(String) onSelectedFilePath;
  @override
  State<ProvidedContent> createState() => _ProvidedContentState();
}

class _ProvidedContentState extends State<ProvidedContent> {
  final quill.QuillController feedbackMessageController =
      quill.QuillController.basic();

  String? selectedFilePath;

  bool isAnonymous = false;

  Future<void> pickFile() async {
    final fileUrl = await FileUploadHelper.pickAndUploadFile();

    if (fileUrl != null) {
      setState(() {
        selectedFilePath = fileUrl;
      });
      showToast(message: 'File uploaded successfully: $fileUrl');
    } else {
      showToast(message: 'File upload failed or was cancelled.');
    }
  }

  @override
  void initState() {
    feedbackMessageController.document =
        quill.Document.fromDelta(widget.feedbackMessage);
    feedbackMessageController.readOnly = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              "Attached File ",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
