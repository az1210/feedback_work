import 'package:feedback_work/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/router/routes.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _messages = [
    {
      "heading": "Welcome!",
      "message": "Welcome to the Feedback Work!",
    },
    {
      "heading": "Refine Your Skills",
      "message":
          "Request constructive feedback, refine your work, and watch your expertise soar—all while getting rewarded.",
    },
    {
      "heading": "Collaborate & Elevate",
      "message":
          "Collaborate with a community of experts, share your Project, and elevate it to the next level.",
    },
    {
      "heading": "Unlock Opportunities",
      "message":
          "Unlock opportunities by connecting with people and grow. Get started now!",
    },
  ];

  void _navigateToNextScreen(BuildContext context, String defaultRoute) {
    final isLoggedIn = ref.watch(authProvider);

    if (isLoggedIn) {
      context.go('/projects');
    } else {
      context.goNamed(Routes.signIn);
    }
  }

  void _goToNext(BuildContext context) {
    if (_currentIndex < _messages.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _navigateToNextScreen(context, '/sign-in');
    }
  }

  void _skip(BuildContext context) {
    _navigateToNextScreen(context, '/sign-in');
  }

  @override
  void initState() {
    Future.microtask(() async {
      final pref = await SharedPreferences.getInstance();
      pref.setBool("firstInstalled", true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          const Image(
            image: AssetImage("assets/images/onboard/frame3.png"),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                const Spacer(flex: 2), // Pushes content down
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/onboard/logo.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 150),
                // Onboarding Heading
                Text(
                  _messages[_currentIndex]['heading']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Onboarding Message
                Text(
                  _messages[_currentIndex]['message']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                // Progress Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _messages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? Colors.white
                            : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2), // Pushes content down further
                // Next and Skip Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _skip(context),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _goToNext(context),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add spacing at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
