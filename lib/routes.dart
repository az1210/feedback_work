import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './screens/onboard/splash_screen.dart';
import './screens/onboard/onboard_screen.dart';
import './screens/auth/sign_up_screen.dart';
import './screens/auth/sign_in_screen.dart';
import './screens/auth/complete_profile_screen.dart';
// import './screens/home_screen.dart';
import './screens/projects/projects_screen.dart';
import './screens/projects/create_project_screen.dart';
import './screens/projects/project_edit_screen.dart';
import './screens/auth/forgot_pass_screen.dart';
import './screens/feedback/feedback_screen.dart';
import './screens/network/network_tab_screen.dart';
import './screens/status/status.dart';
import './screens/more/more_tab_screen.dart';

final authProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => SignInScreen(),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsScreen(),
        ),
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
          path: '/forgot-password',
          builder: (context, state) => ForgotPassScreen(),
        ),
        // GoRoute(
        //   path: '/home-screen',
        //   builder: (context, state) => MyHomePage(),
        // ),
        GoRoute(
          path: '/create-project',
          builder: (context, state) => const CreateProjectScreen(),
        ),
        GoRoute(
          path: '/edit-project',
          builder: (context, state) => const ProjectEditScreen(),
        ),
        GoRoute(
          path: '/feedback',
          builder: (context, state) => FeedbackScreen(),
        ),
        GoRoute(
          path: '/network',
          builder: (context, state) => NetworkTabScreen(),
        ),
        GoRoute(
          path: '/status',
          builder: (context, state) => StatusTabScreen(),
        ),
        GoRoute(
          path: '/more',
          builder: (context, state) => MoreTabScreen(),
        ),
      ],
    );
  },
);
