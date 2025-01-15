import 'dart:io';

import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class TypePrinciple extends ConsumerStatefulWidget {
  const TypePrinciple({super.key});

  @override
  ConsumerState<TypePrinciple> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<TypePrinciple> {
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
                "Type Principle",
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
              16.ph,
            ],
          ),
        ),
      ],
    );
  }
}
