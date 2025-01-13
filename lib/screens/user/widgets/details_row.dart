import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  const DetailRow(
      {super.key,
      required this.title,
      required this.value,
      required this.isValueAligned});

  final String title;
  final String value;
  final bool isValueAligned;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          isValueAligned
              ? Expanded(
                  flex: 11,
                  child: Text(
                    '$title ',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14),
                  ),
                )
              : Text(
                  '$title ',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14),
                ),
          8.pw,
          Expanded(
            flex: isValueAligned ? 10 : 1,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
