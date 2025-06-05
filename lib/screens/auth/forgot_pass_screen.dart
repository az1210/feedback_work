import 'package:feedback_work/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './widgets/block_button.dart';

final emailSentProvider = StateProvider<bool>((ref) => false);

class ForgotPassScreen extends ConsumerWidget {
  final formKey = GlobalKey<FormState>();
  ForgotPassScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  void sendPasswordResetEmail(BuildContext context, WidgetRef ref) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      ref.read(emailSentProvider.notifier).state = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailSent = ref.watch(emailSentProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Stack(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Forgot Password?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 11),
                      Text(
                        "Please enter your email here to get a link to reset your Password",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Enter your email",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color.fromARGB(255, 8, 102, 255),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) => validateEmail(value),
                      ),
                      const SizedBox(height: 25),
                      if (!emailSent)
                        BlockButton(
                          onPressed: emailSent
                              ? () {}
                              : () => sendPasswordResetEmail(context, ref),
                          text: "Send",
                        ),
                      const SizedBox(height: 10),
                      if (emailSent)
                        TextButton(
                          onPressed: () {
                            formKey.currentState!.save();
                            if (formKey.currentState!.validate()) {
                              context.replace('/sign-in');
                            }
                          },
                          child: const Text(
                            "Back to Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
