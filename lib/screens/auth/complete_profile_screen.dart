import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import './widgets/block_button.dart';

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
  String? _selectedAccountType;

  bool _isCheckingUsername = false;
  bool _isUsernameValid = false;

  final List<String> _accountTypes = ['Standard', 'Premium', 'Business'];

  // Real-time username validation
  Future<void> _validateUsername() async {
    final authService = ref.read(authServiceProvider);

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
    final authService = ref.read(authServiceProvider);

    try {
      await authService.completeUserProfile(
        uid: widget.userId,
        username: _usernameController.text.trim(),
        title: _titleController.text.trim(),
        expertise: _expertiseController.text.trim(),
        accountType: _selectedAccountType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                        fillColor: const Color(0xFFF5F5F5),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                    TextField(
                      controller: _expertiseController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
      ),
    );
  }
}
