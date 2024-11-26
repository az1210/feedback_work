import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 3), () {
      final isLoggedIn = ref.read(authProvider);
      if (isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    });

    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("assets/images/onboard/frame0.png"),
            fit: BoxFit.cover,
          ),
          // Image(image: AssetImage(""))
        ],
      ),
    );
  }
}
