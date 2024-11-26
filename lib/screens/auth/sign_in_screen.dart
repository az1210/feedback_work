import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app's logo or splash image
            Image(image: AssetImage("assets/images/splash/frame0.jpg"))
          ],
        ),
      ),
    );
  }
}
