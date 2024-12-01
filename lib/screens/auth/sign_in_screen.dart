import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../providers/auth_providers.dart';
import './widgets/block_button.dart';
import './widgets/or_divider.dart';
import './widgets/third_party_icon_button.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final isChecked = ref.watch(keepMeSignedInProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B1949),
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Let's login to continue for Feedback Work",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  ref
                                      .read(keepMeSignedInProvider.notifier)
                                      .toggle(value ?? false);
                                },
                              ),
                              const Text("Keep me signed in"),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/forgot-password');
                          },
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlockButton(
                      onPressed: () async {
                        final authService = ref.read(authServiceProvider);
                        await handleSignIn(
                          context: context,
                          authService: authService,
                          emailController: emailController,
                          passwordController: passwordController,
                        );
                      },
                      text: "Sign In",
                    ),
                    const SizedBox(height: 25),
                    OrDivider(
                      topText: "Don't have an account?",
                      onTap: () {
                        context.replace('/sign-up');
                      },
                      bottomText: 'Sign Up Here',
                    ),
                    const SizedBox(height: 25),
                    SignInButton(
                      onPressed: () async {
                        try {
                          await authService.signInWithGoogle();
                          context.push('/projects');
                        } catch (e) {
                          // Handle errors
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
                    const SizedBox(height: 20),
                    SignInButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.facebook,
                        color: Color(0xFF0866ff),
                      ),
                      label: const Text("Continue with Facebook"),
                    ),
                    const SizedBox(height: 35),
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

Future<void> handleSignIn({
  required BuildContext context,
  required AuthService authService,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) async {
  try {
    await authService.signInWithEmailOrUsername(
      emailOrUsername: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Show success message or navigate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sign-In Successful!")),
    );
    context.push('/projects');
  } catch (e) {
    // Handle errors and show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
