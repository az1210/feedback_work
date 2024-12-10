import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<void> createProject() async {
    try {
      final projectService = ref.read(projectServiceProvider);
      final currentUser = FirebaseAuth.instance.currentUser;

      await projectService.createProject(
        projectName: projectNameController.text.trim(),
        problemName: problemNameController.text.trim(),
        solutionName: solutionNameController.text.trim(),
        solutionFunctionName: solutionFunctionController.text.trim(),
        projectDescription: projectDescriptionController.text.trim(),
        youtubeLink: youtubeLinkController.text.trim(),
        imageUrl: selectedFilePath ?? '',
        userId: currentUser!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project Created Successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    context.push('/projects');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: const Text('Create Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Project Name*",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: projectNameController,
              decoration: InputDecoration(
                label: Text(
                  "Type here..",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: problemNameController,
              decoration: InputDecoration(
                label: Text(
                  "Type here..",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: solutionNameController,
              decoration: InputDecoration(
                label: Text(
                  "Type here..",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: solutionFunctionController,
              decoration: InputDecoration(
                label: Text(
                  "Type here..",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: projectNameController,
              maxLines: 5,
              decoration: InputDecoration(
                label: Text(
                  "Type here..",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: pickFile,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload,
                        size: 40, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(selectedFilePath ?? 'Upload the file here'),
                    const SizedBox(height: 4),
                    const Text(
                      '(Only .jpg, .png, & .pdf files will be accepted)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: youtubeLinkController,
              decoration: const InputDecoration(
                labelText: 'Youtube Link',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.pop(); // Navigate back
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: createProject,
                  child: const Text('Create Project'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
