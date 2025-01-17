import 'dart:convert';
import 'dart:io';

import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/dotted_border_big_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/new_project_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../providers/project_providers.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController problemNameController = TextEditingController();
  final TextEditingController solutionNameController = TextEditingController();
  final TextEditingController solutionFunctionController =
      TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();

  UserModel? currentUser;
  String? currentUserId;

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

  Future<void> createProject() async {
    try {
      final projectService = ref.read(projectProvider.notifier);

      String? imageUrl;

      // Upload the file to Firebase Storage
      if (selectedFilePath != null && selectedFilePath!.isNotEmpty) {
        imageUrl = await uploadFileToFirebase(selectedFilePath!);
      }

      Log.info(currentUser!.toMap().toString());
      await projectService.createProject(
        project: ProjectModel(
          projectName: projectNameController.text.trim(),
          problemName: problemNameController.text.trim(),
          solutionName: solutionNameController.text.trim(),
          solutionFunctionName:
              solutionFunctionController.text.trim().isNotEmpty
                  ? solutionFunctionController.text.trim()
                  : null,
          projectDescription: projectDescriptionController.document.toDelta(),
          youtubeLink: youtubeLinkController.text.trim().isNotEmpty
              ? youtubeLinkController.text.trim()
              : null,
          imageUrl: imageUrl,
          owner: currentUser,
          ownerId: currentUserId,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project Created Successfully!')),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).currentUser();
      final auth = ref.read(firebaseAuthProvider);
      currentUserId = auth.currentUser!.uid;
    });
    super.initState();
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
    currentUser = ref.watch(currentUserProvider);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: const Text('Create Project'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 19),
                Text(
                  "Project Name*",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: projectNameController,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Problem Name*",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: problemNameController,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Solution Name*",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: solutionNameController,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Solution Function Name",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: solutionFunctionController,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Project Description",
                  style: Theme.of(context).textTheme.titleMedium,
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
                  'Add Image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DottedBorderBigButton(
                  title: selectedFilePath,
                  onTap: pickFile,
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    size: 32.r,
                    color: context.colors.primaryBlue,
                  ),
                  subtitle: "(Only .jpg, .png, & .pdf files will be accepted)",
                ),
                const SizedBox(height: 16),
                Text(
                  "Youtube Link",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: youtubeLinkController,
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
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            height: 84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 8, 102, 255),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color.fromARGB(255, 8, 102, 255),
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: createProject,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    backgroundColor: const Color.fromARGB(255, 8, 102, 255),
                  ),
                  child: Text(
                    'Create Project',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
