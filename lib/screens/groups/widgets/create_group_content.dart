import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/core/utils/validator.dart';
import 'package:feedback_work/screens/groups/widgets/add_member_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateGroupContent extends StatefulWidget {
  const CreateGroupContent({super.key});

  @override
  State<CreateGroupContent> createState() => _CreateGroupContentState();
}

class _CreateGroupContentState extends State<CreateGroupContent> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isPublic = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: context.colors.primaryBlue,
                          fontSize: 14,
                        ),
                  )),
              Text(
                "New Group",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                  onPressed: () {
                    Log.info(_formKey.currentState!.validate().toString());
                    if (_formKey.currentState!.validate()) {
                      context.pop();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: true,
                        showDragHandle: true,
                        backgroundColor: context.colors.background,
                        builder: (context) {
                          return AddMemberContent(
                            groupName: nameController.text,
                            groupDescription: descriptionController.text,
                            isPublic: isPublic,
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    "Next",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: context.colors.primaryBlue,
                          fontSize: 14,
                        ),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Group Name",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                4.ph,
                TextFormField(
                  controller: nameController,
                  decoration: context.inputDecor
                      .outlinedInputDecor(
                          fillColor: context.colors.pureWhite,
                          borderRadius: BorderRadius.circular(10.r),
                          hint: "Group Name")
                      .copyWith(filled: true),
                  validator: (value) =>
                      validateInput(value, fieldName: 'Group Name'),
                ),
                8.ph,
                Row(
                  children: [
                    Text(
                      "Group Description",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                4.ph,
                TextFormField(
                  controller: descriptionController,
                  decoration: context.inputDecor
                      .outlinedInputDecor(
                          hint: "Group Description",
                          fillColor: context.colors.pureWhite,
                          borderRadius: BorderRadius.circular(10.r))
                      .copyWith(filled: true),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) =>
                      validateInput(value, fieldName: 'Group Description'),
                ),
                8.ph,
                Row(
                  children: [
                    Text(
                      "Select Group Privacy",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                4.ph,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  // height: 40.h,
                  decoration: BoxDecoration(
                      color: context.colors.pureWhite,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Public Group",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                      Switch(
                          value: isPublic,
                          onChanged: (val) {
                            setState(() {
                              isPublic = val;
                            });
                          })
                    ],
                  ),
                ),
                16.ph,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
