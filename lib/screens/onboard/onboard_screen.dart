import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;

  final List<String> _messages = [
    "Welcome to the Feedback Work!",
    "Request constructive feedback, refine your work, and watch your expertise soar—all while getting rewarded.",
    "Collaborate with a community of experts, share your Project, and elevate it to the next level.",
    "Unlock opportunities by connecting with people and grow. Get started now!",
  ];

  void _goToNext(BuildContext context) {
    if (_currentIndex < _messages.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      context.go('/sign-up');
    }
  }

  void _skip(BuildContext context) {
    context.go('/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.read(authProvider);

    if (isLoggedIn) {
      Future.microtask(() => context.go('/home'));
    }

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
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/onboard/logo.png',
                    height: 100, // Adjust height as necessary
                    width: 100, // Optional: Add width constraint
                  ),
                ),
                const Spacer(),
                // Onboarding Message
                Text(
                  _messages[_currentIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 40),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
