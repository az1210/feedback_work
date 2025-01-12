import 'package:feedback_work/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      final authService = ref.read(authServiceProvider.notifier);
      ref.read(authProvider.notifier).state =
          await authService.isUserSignedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> navigateBasedOnAuth() async {
      // if (isSignedIn) {
      //   context.go('/projects');
      // } else {
      context.go('/onboarding');
      // }
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
