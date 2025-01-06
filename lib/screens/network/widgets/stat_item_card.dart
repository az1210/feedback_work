import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class StatItemCard extends StatelessWidget {
  const StatItemCard(
      {super.key,
      required this.value,
      required this.label,
      required this.valueColor});
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.inputBorder),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
