import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/screens/user/widgets/details_row.dart';
import 'package:flutter/material.dart';

class FeedbackReceiptHeaderSection extends StatelessWidget {
  final String feedbackRequestDate;
  final String feedbackProvidedDate;
  final String providerName;
  final String requesterName;

  const FeedbackReceiptHeaderSection({
    super.key,
    required this.feedbackRequestDate,
    required this.feedbackProvidedDate,
    required this.providerName,
    required this.requesterName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.inputBorder,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(
            title: 'Feedback request date:',
            value: feedbackRequestDate,
            isValueAligned: true,
          ),
          DetailRow(
            title: 'Feedback provided date:',
            value: feedbackProvidedDate,
            isValueAligned: true,
          ),
          DetailRow(
            title: 'Provider Name',
            value: providerName,
            isValueAligned: true,
          ),
          DetailRow(
            title: 'Requester Name',
            value: requesterName,
            isValueAligned: true,
          ),
        ],
      ),
    );
  }
}
