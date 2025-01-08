import 'dart:io';

import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class TypeMessage extends ConsumerStatefulWidget {
  const TypeMessage({super.key});

  @override
  ConsumerState<TypeMessage> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<TypeMessage> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController problemNameController = TextEditingController();
  final TextEditingController solutionNameController = TextEditingController();
  final TextEditingController solutionFunctionController =
      TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();

  final quill.QuillController projectDescriptionController =
      quill.QuillController.basic();

  bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  String? selectedFilePath;

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

  Future<String> uploadFileToFirebase(String filePath) async {
    final fileName = filePath.split('/').last; // Extract the file name
    final storageRef = FirebaseStorage.instance.ref().child(
        'project_images/$fileName'); // Create a reference in Firebase Storage

    final file = File(filePath); // Local file reference

    await storageRef.putFile(file);

    return await storageRef.getDownloadURL();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    problemNameController.dispose();
    solutionNameController.dispose();
    solutionFunctionController.dispose();
    youtubeLinkController.dispose();
    projectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardVisible = isKeyboardVisible(context);

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

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feedback Subject",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              TextField(
                controller: solutionFunctionController,
                decoration: InputDecoration(
                  hintText: "Type here",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  filled: true,
                  fillColor: context.colors.pureWhite,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Feedback Message",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              if (!keyboardVisible)
                quill.QuillToolbar.simple(
                  controller: projectDescriptionController,
                  configurations: config,
                ),
              const SizedBox(height: 8),
              // Quill Editor
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: quill.QuillEditor.basic(
                  controller: projectDescriptionController,
                  focusNode: FocusNode(),

                  // padding: const EdgeInsets.all(16),
                  // autoFocus: true,
                  // showCursor: true,
                  // enableInteractiveSelection: true,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Attach File',
                style: Theme.of(context).textTheme.bodyMedium,
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
                      padding:
                          const EdgeInsets.only(left: 12, top: 12, bottom: 12),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Youtube Link",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              TextField(
                controller: youtubeLinkController,
                decoration: InputDecoration(
                  hintText: "Insert link",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
