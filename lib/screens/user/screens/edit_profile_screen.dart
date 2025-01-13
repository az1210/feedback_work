import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/category_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({required this.currentUser, super.key});
  final UserModel currentUser;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();

  final FocusNode expertiseFocusNode = FocusNode();

  final List<String> _accountTypes = [
    'Ragular',
    'Parent',
    'Manager',
    'Teacher',
    'Business'
  ];

  String? _selectedAccountType;

  @override
  void initState() {
    firstNameController.text = widget.currentUser.firstName ?? "";
    lastNameController.text = widget.currentUser.lastName ?? "";
    emailController.text = widget.currentUser.email ?? "";
    phoneNumberController.text = widget.currentUser.phoneNumber ?? "";
    usernameController.text = widget.currentUser.username ?? "";
    titleController.text = widget.currentUser.title ?? "";
    _selectedAccountType = widget.currentUser.accountType;
    Future.microtask(() {
      ref.read(categoryProvider.notifier).fetchAllCategories();
    });
    super.initState();
  }

  List<CategoryModel> categories = [];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    ref.listen(categoryProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        Log.info(newState.data.toString());
        final data = newState.data;
        if (data != null || data!.isNotEmpty) {
          categories = newState.data!;
        }
      }
    });
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Update",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: context.colors.primaryBlue,
                      fontSize: 14,
                    ),
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                "First Name",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.inputBorder,
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
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r)),
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
                  fillColor: context.colors.inputBorder,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                readOnly: true,
              ),
              16.ph,
              Text(
                "Phone Number",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              16.ph,
              Text(
                "Username(Optional)",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: usernameController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              16.ph,
              Text(
                "Title",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              TextFormField(
                controller: titleController,
                decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              16.ph,
              Text(
                "Expertise",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              Builder(builder: (context) {
                if (categoryState.state == AsyncState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (categoryState.state == AsyncState.failure) {
                  return const Center(
                    child: Text("Can't fetch category"),
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownMenu(
                          focusNode: expertiseFocusNode,
                          controller: expertiseController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: widget.currentUser.expertise,
                          hintText: 'Select Expertise Category',
                          onSelected: (value) {
                            expertiseFocusNode.unfocus();
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          width: double.infinity,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: context.colors.inputBorder,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: context.colors.transparent),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: context.colors.transparent),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: context.colors.transparent),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          dropdownMenuEntries: categories
                              .map(
                                (c) => DropdownMenuEntry(
                                    value: c.categoryTitle,
                                    label: c.categoryTitle),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }
              }),
              16.ph,
              Text(
                "Account Type",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                hint: const Text("Select account type"),
                items: _accountTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.colors.inputBorder,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              16.ph,
              AppButton.filled(
                label: "Manage Children",
                onTap: () {
                  context.pushNamed(Routes.parentAndChildren);
                },
                bgColor: context.colors.primaryBlue.withValues(
                  alpha: 0.2,
                ),
                fgColor: context.colors.primaryBlue,
                verticalPadding: 10,
              ),
              16.ph,
              AppButton.filled(
                label: "Update",
                onTap: () {},
                bgColor: context.colors.primaryBlue,
                verticalPadding: 10,
              ),
              16.ph,
            ],
          ),
        ),
      ),
    );
  }
}
