import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/onboard/splash_screen.dart';
import './screens/onboard/onboard_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import './screens/auth/complete_profile_screen.dart';
// import './screens/home_screen.dart';
// import './screens/profile_screen.dart';

// Provider to simulate authentication state
final authProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>(
  (ref) {
    final isLoggedIn = ref.watch(authProvider);

    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const OnboardingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Configure left-to-right transition
                const begin = Offset(1.0, 0.0); // Start from the left
                const end = Offset.zero; // End at the current position
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1),
            );
          },
        ),
        // GoRoute(
        //   path: '/onboarding',
        //   builder: (context, state) => const OnboardingScreen(),
        // ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/complete-profile',
          builder: (context, state) {
            final userId = state.extra as String;
            return CompleteProfileScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => SignInScreen(),
        ),

        // GoRoute(
        //   path: '/home',
        //   builder: (context, state) => const HomeScreen(),
        //   routes: [
        //     GoRoute(
        //       path: 'profile',
        //       builder: (context, state) => const ProfileScreen(),
        //     ),
        //   ],
        // ),
      ],
      // redirect: (context, state) {
      //   // Handle redirection based on authentication state
      //   if (!isLoggedIn &&
      //       state.location != '/sign-in' &&
      //       state.location != '/onboarding') {
      //     return '/sign-in'; // Redirect unauthenticated users to sign-in
      //   }
      //   if (isLoggedIn &&
      //       (state.location == '/sign-in' || state.location == '/onboarding')) {
      //     return '/home'; // Redirect authenticated users to home
      //   }
      //   return null; // No redirection
      // },
    );
  },
);
