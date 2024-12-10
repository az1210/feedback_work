import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

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
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();

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

    // Upload the file
    await storageRef.putFile(file);

    // Get the download URL
    return await storageRef.getDownloadURL();
  }

  Future<void> createProject() async {
    if (selectedFilePath == null || selectedFilePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image!')),
      );
      return;
    }

    try {
      final projectService = ref.read(projectServiceProvider);
      final currentUser = FirebaseAuth.instance.currentUser;

      // Upload the file to Firebase Storage
      final imageUrl = await uploadFileToFirebase(selectedFilePath!);

      await projectService.createProject(
        projectName: projectNameController.text.trim(),
        problemName: problemNameController.text.trim(),
        solutionName: solutionNameController.text.trim(),
        solutionFunctionName: solutionFunctionController.text.trim(),
        projectDescription: projectDescriptionController.text.trim(),
        youtubeLink: youtubeLinkController.text.trim(),
        imageUrl: imageUrl,
        userId: currentUser!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project Created Successfully!')),
      );

      context.push('/projects');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    fillColor: const Color(0xFFF5F5F5),
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
                    fillColor: const Color(0xFFF5F5F5),
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
                    fillColor: const Color(0xFFF5F5F5),
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
                    fillColor: const Color(0xFFF5F5F5),
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
                TextField(
                  controller: projectDescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add Image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: pickFile,
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      // padding: const EdgeInsets.all(16),
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashPattern: const [8, 8],
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, top: 12, bottom: 12),
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: youtubeLinkController,
                  decoration: InputDecoration(
                    hintText: "Insert link here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
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
