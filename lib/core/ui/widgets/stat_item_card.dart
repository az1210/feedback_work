import 'package:flutter/material.dart';

class StateItemCard extends StatelessWidget {
  const StateItemCard({
    super.key,
    required this.context,
    required this.value,
    required this.label,
    required this.color,
  });

  final BuildContext context;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
