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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTap,
              child: Text(
                bottomText,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color.fromARGB(255, 8, 102, 255)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
