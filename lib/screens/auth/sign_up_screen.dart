import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import './widgets/third_party_icon_button.dart';
import './widgets/or_divider.dart';
import './widgets/block_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isObscured = true;
  final Map<String, String?> _errorMessages = {};

  void handleSignUp() async {
    if (!_validateInputs()) return;
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    try {
      await ref.read(authServiceProvider).signUp(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            phoneNumber: phoneNumberController.text.trim(),
          );

      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        context.push('/complete-profile', extra: userId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  bool _validateInputs() {
    setState(() {
      _errorMessages.clear();
      if (firstNameController.text.trim().isEmpty) {
        _errorMessages['firstName'] = "First name is required.";
      }
      if (lastNameController.text.trim().isEmpty) {
        _errorMessages['lastName'] = "Last name is required.";
      }
      if (emailController.text.trim().isEmpty) {
        _errorMessages['email'] = "Email is required.";
      }
      if (phoneNumberController.text.trim().isEmpty) {
        _errorMessages['phoneNumber'] = "Phone number is required.";
      }
      if (passwordController.text.isEmpty) {
        _errorMessages['password'] = "Password is required.";
      }
      if (confirmPasswordController.text.isEmpty) {
        _errorMessages['confirmPassword'] =
            "Password confirmation is required.";
      }
    });

    return _errorMessages.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // LayoutBuilder(
        //   builder: (context, constraints) {
        //     bool isWideScreen = constraints.maxWidth > 800;
        const Align(
          alignment: Alignment.topCenter,
          child: Image(
            image: AssetImage("assets/images/onboard/top1.jpeg"),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 230,
          ),
        ),
        Positioned(
          top: 200,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Container(
              // width: isWideScreen ? 700 : double.infinity,
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
                  const SizedBox(height: 10),
                  Text(
                    "Create Your Account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create Account for Feedback Work",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "First Name",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['firstName'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        context.push('/projects');
                      },
                      child: Text(
                        'Development Button',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Text(
                    "Last Name",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['lastName'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['email'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Phone Number",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['phoneNumber'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Password",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['password'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Re-enter Password",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      errorText: _errorMessages['confirmPassword'],
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlockButton(onPressed: handleSignUp, text: "Create Account"),
                  const SizedBox(height: 16),
                  OrDivider(
                    topText: 'Have an Account?',
                    onTap: () {
                      context.go('/sign-in');
                    },
                    bottomText: 'Sign In Here',
                  ),
                  const SizedBox(height: 16),
                  SignInButton(
                    onPressed: () async {
                      try {
                        await authService.signInWithGoogle();
                        context.push('/projects');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    icon: Image.asset(
                      "assets/images/icons/g-logo.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Continue with Google"),
                  ),
                  const SizedBox(height: 12),
                  SignInButton(
                    onPressed: () async {
                      try {
                        await authService.signInWithFacebook();
                        context.push('/projects');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.facebook,
                      color: Color.fromARGB(255, 8, 102, 255),
                    ),
                    label: const Text("Continue with Facebook"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
