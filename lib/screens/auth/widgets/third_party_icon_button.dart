import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final dynamic icon;
  final dynamic label;

  const SignInButton(
      {required this.onPressed, this.icon, this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 15, letterSpacing: 0.7),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.grey),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
