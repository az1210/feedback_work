import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> navigateBasedOnAuth() async {
      final authService = ref.read(authServiceProvider.notifier);

      final isSignedIn = await authService.isUserSignedIn();

      if (isSignedIn) {
        context.go('/projects');
      } else {
        context.go('/onboarding');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), navigateBasedOnAuth);
    });

    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("assets/images/onboard/frame0.png"),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
