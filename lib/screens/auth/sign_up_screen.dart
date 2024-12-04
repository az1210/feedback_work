import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import './widgets/third_party_icon_button.dart';
import './widgets/or_divider.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Stack(
            children: [
              const Image(
                image: AssetImage("assets/images/onboard/bg.png"),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(28, 26, 74, 1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: isWideScreen ? 700 : double.infinity,
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
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B1949),
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create Account for Feedback Work",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['firstName'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['lastName'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['email'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['phoneNumber'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              labelText: "Password",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['password'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              labelText: "Re-enter Password",
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              errorText: _errorMessages['confirmPassword'],
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0866ff),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          OrDivider(
                            topText: 'Have an Account?',
                            onTap: () {
                              context.go('/sign-in');
                            },
                            bottomText: 'Sign In Here',
                          ),
                          const SizedBox(height: 15),
                          SignInButton(
                            onPressed: () async {
                              try {
                                await authService.signInWithGoogle();
                                context.go('/home');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                            icon: Image.asset(
                              'assets/images/icons/g_icon.png',
                              height: 24,
                              width: 24,
                            ),
                            label: const Text("Continue with Google"),
                          ),
                          const SizedBox(height: 15),
                          SignInButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.facebook,
                              color: Color(0xFF0866ff),
                            ),
                            label: const Text("Continue with Facebook"),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
