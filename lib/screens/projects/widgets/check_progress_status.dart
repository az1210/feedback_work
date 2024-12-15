import 'package:flutter/material.dart';

class CheckProgressStatus extends StatelessWidget {
  final String title;
  final String subtitle;
  const CheckProgressStatus({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          children: [
            Image(
              image: AssetImage("assets/images/icons/step.png"),
              height: 20.4,
            ),
            Image(
              image: AssetImage("assets/images/icons/line1.png"),
              color: Color.fromARGB(255, 8, 102, 255),
              height: 47.6,
            ),
          ],
        ),
        const SizedBox(width: 7.93),
        Transform.translate(
          offset: const Offset(0, -5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.33,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 101, 103, 107),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
