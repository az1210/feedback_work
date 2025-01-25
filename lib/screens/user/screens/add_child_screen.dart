import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/child_model.dart';
import 'package:feedback_work/providers/auth_providers.dart';
import 'package:feedback_work/providers/child_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({required this.parentId, super.key});

  final String parentId;

  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscured = true;

  final sections = [
    FilterSection(
      title: 'ageRange',
      values: ['0-5', '5-17', '17-23'],
      labels: ['0-5', '5-17', '17-23'],
      allowMultipleSelection: false,
    ),
    FilterSection(
      title: 'grade',
      values: ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade'],
      labels: ['1st Grade', '2nd Grade', '3rd Grade', '4th Grade'],
      allowMultipleSelection: false,
    ),
  ];
  Map<String, Set<String>> selectedFilters = {
    'ageRange': {'0-5'},
    'grade': {'1st Grade'}
  };

  String? selectedAgeRange;
  String? selectedGrade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Child"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.pureWhite,
                          border: Border.all(
                            color: context.colors.darkGrey,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit_outlined,
                            color: context.colors.primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.ph,
              Text(
                "First Name",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.pureWhite,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              16.ph,
              Text(
                "Last Name",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.pureWhite,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              FilterContent(
                sections: sections,
                hasActionButton: false,
                hasHeader: false,
                hasSearchOption: false,
                selectedFilters: selectedFilters,
                onFiltersChanged: (selectedFilters) {
                  selectedAgeRange = selectedFilters.containsKey("ageRange")
                      ? selectedFilters['ageRange']?.first
                      : null;
                  selectedGrade = selectedFilters.containsKey('grade')
                      ? selectedFilters['grade']?.first
                      : null;
                  setState(() {});
                },
              ),
              16.ph,
              Text(
                "Email",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: emailController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.pureWhite,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              16.ph,
              Text(
                "Password",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: context.inputDecor.outlinedInputDecor(
                  fillColor: context.colors.pureWhite,
                  borderRadius: BorderRadius.circular(8.r),
                  suffix: IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
                obscureText: _isObscured,
              ),
              16.ph,
              Text(
                "Re-enter Password",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: context.inputDecor.outlinedInputDecor(
                  fillColor: context.colors.pureWhite,
                  borderRadius: BorderRadius.circular(8.r),
                  suffix: IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
                obscureText: _isObscured,
              ),
              16.ph,
              AppButton.filled(
                label: "Save",
                onTap: () {
                  ref.read(childProvider.notifier).createChildAccount(
                        childModel: ChildModel(
                          ageRange: selectedAgeRange!,
                          email: emailController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          grade: selectedGrade!,
                        ),
                        password: passwordController.text,
                        parentId: widget.parentId,
                        callBack: () {
                          context.pop();
                        },
                      );
                },
                verticalPadding: 12.h,
              ),
              16.ph,
            ],
          ),
        ),
      ),
    );
  }
}
