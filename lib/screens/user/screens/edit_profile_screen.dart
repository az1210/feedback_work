import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/core/utils/validator.dart';
import 'package:feedback_work/models/category_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/auth_providers.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
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
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController minimumRateController = TextEditingController();

  final FocusNode expertiseFocusNode = FocusNode();

  final List<String> _accountTypes = [
    'Ragular',
    'Parent',
    'Manager',
    'Teacher',
    'Business'
  ];

  String? selectedAccountType;
  bool _isCheckingUsername = false;
  bool _isUsernameValid = true;

  // Real-time username validation
  Future<void> _validateUsername() async {
    final authService = ref.read(authServiceProvider.notifier);

    setState(() {
      _isCheckingUsername = true;
    });

    bool isAvailable = await authService.isUsernameAvailable(
      usernameController.text.trim(),
    );

    setState(() {
      _isCheckingUsername = false;
      _isUsernameValid = isAvailable;
    });
  }

  @override
  void initState() {
    firstNameController.text = widget.currentUser.firstName ?? "";
    lastNameController.text = widget.currentUser.lastName ?? "";
    emailController.text = widget.currentUser.email ?? "";
    phoneNumberController.text = widget.currentUser.phoneNumber ?? "";
    usernameController.text = widget.currentUser.username ?? "";
    titleController.text = widget.currentUser.title ?? "";
    selectedAccountType = widget.currentUser.accountType;
    minimumRateController.text =
        widget.currentUser.minimumRate.toString() ?? "0.0";
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
            onPressed: () {
              ref.read(userProvider.notifier).updateProfile(
                    uid: widget.currentUser.id!,
                    userModel: UserModel(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      phoneNumber: phoneNumberController.text.trim(),
                      username: usernameController.text.trim(),
                      title: titleController.text.trim(),
                      expertise: expertiseController.text.trim(),
                      accountType: selectedAccountType ?? '',
                      minimumRate:
                          double.tryParse(minimumRateController.text.trim()) ??
                              -1,
                    ),
                    callback: () {
                      context.pop();
                    },
                  );
            },
            child: Text(
              "Update",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: context.colors.primaryBlue,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
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
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  validator: (value) =>
                      validateInput(value, fieldName: 'First Name'),
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
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  validator: (value) =>
                      validateInput(value, fieldName: 'Last Name'),
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
                  validator: (value) => validateEmail(value),
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
                    borderRadius: BorderRadius.circular(8.r),
                  ),
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
                  onChanged: (value) => _validateUsername(),
                  decoration: context.inputDecor.outlinedInputDecor(
                    suffix: _isCheckingUsername
                        ? const CircularProgressIndicator()
                        : Icon(
                            _isUsernameValid
                                ? Icons.check_circle
                                : Icons.error_outline,
                            color: _isUsernameValid
                                ? Colors.green
                                : Colors.redAccent,
                          ),
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  validator: (value) =>
                      validateInput(value, fieldName: 'Username'),
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
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  validator: (value) =>
                      validateInput(value, fieldName: 'Title'),
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
                                borderSide: BorderSide(
                                    color: context.colors.transparent),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: context.colors.transparent),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: context.colors.transparent),
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
                  value: selectedAccountType,
                  hint: const Text("Select account type"),
                  items: _accountTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAccountType = value;
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
                Text(
                  "Minimum Rate",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                TextFormField(
                  controller: minimumRateController,
                  decoration: context.inputDecor.outlinedInputDecor(
                    fillColor: context.colors.inputBorder,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                16.ph,
                AppButton.filled(
                  label: "Manage Children",
                  onTap: () {
                    context.pushNamed(Routes.parentAndChildren,
                        extra: widget.currentUser.id);
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
                  onTap: () {
                    formKey.currentState!.save();
                    if (formKey.currentState!.validate()) {
                      ref.read(userProvider.notifier).updateProfile(
                            uid: widget.currentUser.id!,
                            userModel: UserModel(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              phoneNumber: phoneNumberController.text.trim(),
                              username: usernameController.text.trim(),
                              title: titleController.text.trim(),
                              expertise: expertiseController.text.trim(),
                              accountType: selectedAccountType ?? '',
                              minimumRate: double.tryParse(
                                      minimumRateController.text.trim()) ??
                                  -1,
                            ),
                            callback: () {
                              context.pop();
                            },
                          );
                    }
                  },
                  bgColor: context.colors.primaryBlue,
                  verticalPadding: 10,
                ),
                16.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
