import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/file_upload_helper.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Before extends ConsumerStatefulWidget {
  const Before({
    super.key,
    required this.onSelectFilePath,
    required this.onChangeYTlink,
  });

  final void Function(String?) onSelectFilePath;
  final void Function(String?) onChangeYTlink;

  @override
  ConsumerState<Before> createState() => _BeforeState();
}

class _BeforeState extends ConsumerState<Before> {
  String? selectedFilePath;

  Future<void> pickFile() async {
    final fileUrl = await FileUploadHelper.pickAndUploadFile();

    if (fileUrl != null) {
      setState(() {
        selectedFilePath = fileUrl;
        widget.onSelectFilePath(fileUrl);
      });
      showToast(message: 'File uploaded successfully: $fileUrl');
    } else {
      showToast(message: 'File upload failed or was cancelled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Attach File',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: pickFile,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                // padding: const EdgeInsets.all(16),
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
          16.ph,
          Row(
            children: [
              Text(
                "Youtube Link",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            onChanged: (value) {
              setState(() {
                widget.onChangeYTlink(value);
              });
            },
            decoration: InputDecoration(
              hintText: "Insert link here",
              hintStyle: Theme.of(context).textTheme.bodySmall,
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
                validateInput(value, fieldName: 'YouTube Link'),
          ),
        ],
      ),
    );
  }
}
