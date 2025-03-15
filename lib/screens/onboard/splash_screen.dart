// import 'package:feedback_work/core/router/routes.dart';
// import 'package:feedback_work/core/utils/utils.dart';
// import 'package:feedback_work/providers/user_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../providers/auth_providers.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     Future.microtask(() async {
//       final authService = ref.read(authServiceProvider.notifier);
//       ref.read(authProvider.notifier).state =
//           await authService.isUserSignedIn();
//       if (ref.watch(authProvider)) {
//         ref.read(currentUserProvider.notifier).state =
//             await ref.read(userProvider.notifier).currentUser();
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<void> navigateBasedOnAuth() async {
//       final pref = await SharedPreferences.getInstance();

//       // if (!mounted) return;
//       if (pref.getBool("firstInstalled") == null) {
//         Log.info(pref.getBool("firstInstalled").toString());
//         context.go('/onboarding');
//       } else {
//         context.goNamed(Routes.signIn);
//       }
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(seconds: 3), navigateBasedOnAuth);
//     });

//     return const Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image(
//             image: AssetImage("assets/images/onboard/frame0.png"),
//             fit: BoxFit.cover,
//           ),
//         ],
//       ),
//     );
//   }
// }

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
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authService = ref.read(authServiceProvider.notifier);

    /// Check if user is logged in
    final isLoggedIn = await authService.isUserSignedIn();
    ref.read(authProvider.notifier).state = isLoggedIn;

    /// If logged in, fetch current user details
    if (isLoggedIn) {
      final user = await ref.read(userProvider.notifier).currentUser();
      ref.read(currentUserProvider.notifier).state = user;
    }

    /// Check if onboarding should be shown
    final pref = await SharedPreferences.getInstance();
    final isFirstInstall = pref.getBool("firstInstalled") ?? false;

    /// Navigate to the correct screen
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 3), () {
      if (!isLoggedIn) {
        /// If user is not logged in, check onboarding
        if (isFirstInstall) {
          context.go('/onboarding');
        } else {
          context.go(Routes.signIn.p);
        }
      } else {
        /// If user is logged in, go to projects
        context.go(Routes.projects.p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
