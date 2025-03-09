import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      if (ref.watch(authProvider)) {
        ref.read(currentUserProvider.notifier).state =
            await ref.read(userProvider.notifier).currentUser();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> navigateBasedOnAuth() async {
      final pref = await SharedPreferences.getInstance();

      // if (!mounted) return;
      if (pref.getBool("firstInstalled") == null) {
        Log.info(pref.getBool("firstInstalled").toString());
        context.go('/onboarding');
      } else {
        context.goNamed(Routes.signIn);
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
