import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final VoidCallback onTap;
  final String topText;
  final String bottomText;

  const OrDivider(
      {required this.onTap,
      required this.topText,
      required this.bottomText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              topText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTap,
              child: Text(
                bottomText,
                style: const TextStyle(
                  color: Color(0xFF0866ff),
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Or",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
