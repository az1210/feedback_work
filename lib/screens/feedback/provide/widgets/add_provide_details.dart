import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/file_upload_helper.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProvideDetails extends ConsumerStatefulWidget {
  AddProvideDetails({required this.onUpdatePeople, super.key});

  Function(ProvideInfoModel) onUpdatePeople;
  @override
  ConsumerState<AddProvideDetails> createState() => _BeforeState();
}

class _BeforeState extends ConsumerState<AddProvideDetails> {
  final _formKey = GlobalKey<FormState>();
  final ProvideInfoModel peoples = ProvideInfoModel();
  final TextEditingController nameController = TextEditingController();
  String? selectedFilePath;

  // void addAnotherPerson() {
  //   setState(() {
  //     peoples.add(PeopleInfoModel());
  //     nameControllers.add(TextEditingController());
  //   });
  // }

  void update() {
    if (_formKey.currentState!.validate()) {
      // Update people list with current values
      // for (var i = 0; i < peoples.length; i++) {
      //   Log.info(nameControllers[i].text);
      // }
      peoples.name = nameController.text;

      // Send data to parent
      widget.onUpdatePeople(peoples);
    }
  }

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
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Headline",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a headline';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  update();
                },
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
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 16.ph,
              // GestureDetector(
              //   onTap: addAnotherPerson,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.add_circle,
              //         color: context.colors.primaryBlue,
              //       ),
              //       8.pw,
              //       Text(
              //         "Add another person",
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodyMedium!
              //             .copyWith(color: context.colors.primaryBlue),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
