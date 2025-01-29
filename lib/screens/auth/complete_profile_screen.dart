import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/category_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../providers/auth_providers.dart';
import './widgets/block_button.dart';
import '../../utility/custom_snackbar.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  final String userId; // Pass the user's UID from the previous screen

  const CompleteProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _minimumRateController = TextEditingController();
  final FocusNode _expertiseFocusNode = FocusNode();
  String? _selectedAccountType;

  bool _isCheckingUsername = false;
  bool _isUsernameValid = false;

  final List<String> _accountTypes = [
    'Ragular',
    'Parent',
    'Manager',
    'Teacher',
  ];

  // Real-time username validation
  Future<void> _validateUsername() async {
    final authService = ref.read(authServiceProvider.notifier);

    setState(() {
      _isCheckingUsername = true;
    });

    bool isAvailable = await authService.isUsernameAvailable(
      _usernameController.text.trim(),
    );

    setState(() {
      _isCheckingUsername = false;
      _isUsernameValid = isAvailable;
    });
  }

  // Submit user profile
  Future<void> _submitProfile() async {
    final authService = ref.read(authServiceProvider.notifier);

    try {
      await authService.completeUserProfile(
        uid: widget.userId,
        userModel: UserModel(
          username: _usernameController.text.trim(),
          title: _titleController.text.trim(),
          expertise: _expertiseController.text.trim(),
          accountType: _selectedAccountType ?? '',
          minimumRate: double.tryParse(_minimumRateController.text.trim()) ?? 0,
        ),
      );

      final snackBar = CustomSnackbar.build(
        title: 'Congratulations!',
        message: 'You have successfully created a Feedback Work account',
        contentType: ContentType.success,
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      context.replace('/sign-in'); // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Error: $e",
          style: const TextStyle(
            color: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
        )),
      );
    }
  }

  @override
  void initState() {
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
      body: Builder(builder: (context) {
        if (categoryState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (categoryState.state == AsyncState.failure) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage("assets/images/onboard/top1.jpeg"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 230,
                ),
              ),
              // Positioned(
              //   top: 40,
              //   left: 20,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.7),
              //         shape: BoxShape.circle,
              //         boxShadow: const [
              //           BoxShadow(
              //             color: Colors.black12,
              //             blurRadius: 4,
              //             offset: Offset(2, 2),
              //           ),
              //         ],
              //       ),
              //       padding: const EdgeInsets.all(8),
              //       child: Icon(
              //         Theme.of(context).platform == TargetPlatform.iOS
              //             ? Icons.arrow_back_ios
              //             : Icons.arrow_back,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Complete Your Profile",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            "assets/images/icons/profile-frame.png",
                            height: 78,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Username (Optional)",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _usernameController,
                          onChanged: (value) => _validateUsername(),
                          decoration: InputDecoration(
                            suffixIcon: _isCheckingUsername
                                ? const CircularProgressIndicator()
                                : Icon(
                                    _isUsernameValid
                                        ? Icons.check_circle
                                        : Icons.error_outline,
                                    color: _isUsernameValid
                                        ? Colors.green
                                        : Colors.redAccent,
                                  ),
                            filled: true,
                            fillColor: context.colors.inputBorder,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Title",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: context.colors.inputBorder,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Expertise",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        DropdownMenu(
                          focusNode: _expertiseFocusNode,
                          controller: _expertiseController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          hintText: 'Select Expertise Category',
                          onSelected: (value) {
                            _expertiseFocusNode.unfocus();
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          width: 1.sw - 64,
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
                        const SizedBox(height: 16),
                        Text(
                          "Minimum Rate",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _minimumRateController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlockButton(
                          onPressed: _submitProfile,
                          text: 'Submit',
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
