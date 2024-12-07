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
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 11),
                    Text(
                      "Let's login to continue for Feedback Work",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Email",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 11),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter your Email",
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF0866ff),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Enter your Password",
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF0866ff),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
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
                              Flexible(
                                child: Text(
                                  "Keep me signed in",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () {
                              context.go('/forgot-password');
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        const Color.fromARGB(255, 8, 102, 255),
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
                    const SizedBox(height: 24),
                    OrDivider(
                      topText: "Don't have an account?",
                      onTap: () {
                        context.replace('/sign-up');
                      },
                      bottomText: 'Sign Up here',
                    ),
                    const SizedBox(height: 16),
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
                        'assets/images/icons/g-logo.png',
                        height: 16,
                        width: 16,
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
                          // Handle errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.facebook,
                        color: Color(0xFF0866ff),
                      ),
                      label: const Text("Continue with Facebook"),
                    ),
                    const SizedBox(height: 20),
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
