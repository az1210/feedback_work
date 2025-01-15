import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPeopleDetails extends ConsumerStatefulWidget {
  const AddPeopleDetails({super.key});

  @override
  ConsumerState<AddPeopleDetails> createState() => _BeforeState();
}

class _BeforeState extends ConsumerState<AddPeopleDetails> {
  final TextEditingController youtubeLinkController = TextEditingController();
  String? selectedFilePath;

  List<ProvideFeedbackPeopleModel> peoples = [ProvideFeedbackPeopleModel()];

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
    final firebaseStorage = ref.read(storageProvider);
    final storageRef = firebaseStorage.ref().child(
        'project_images/$fileName'); // Create a reference in Firebase Storage

    final file = File(filePath); // Local file reference

    await storageRef.putFile(file);

    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Name of People(${index + 1})",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: youtubeLinkController,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  16.ph,
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
              ),
              separatorBuilder: (_, __) => 16.ph,
              itemCount: peoples.length,
            ),
            16.ph,
            GestureDetector(
              onTap: () {
                setState(() {
                  peoples.add(ProvideFeedbackPeopleModel());
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle,
                    color: context.colors.primaryBlue,
                  ),
                  8.pw,
                  Text(
                    "Add another person",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: context.colors.primaryBlue),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
