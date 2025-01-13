import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/screens/user/widgets/details_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptCard extends StatelessWidget {
  final String name;
  final String date;
  final String profileImageUrl;
  final String project;
  final String problem;
  final String solution;
  final String solutionFunction;
  final String subject;
  final String amount;
  final VoidCallback onViewReceipt;

  const ReceiptCard({
    super.key,
    required this.name,
    required this.date,
    required this.profileImageUrl,
    required this.project,
    required this.problem,
    required this.solution,
    required this.solutionFunction,
    required this.subject,
    required this.amount,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          color: context.colors.darkGrey,
                        ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.successGreen),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      amount,
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Project Details
          DetailRow(
            title: 'Project',
            value: project,
            isValueAligned: false,
          ),
          Divider(
            color: context.colors.inputBorder,
          ),
          DetailRow(
            title: 'Problem',
            value: problem,
            isValueAligned: false,
          ),
          Divider(
            color: context.colors.inputBorder,
          ),
          DetailRow(
            title: 'Solution',
            value: solution,
            isValueAligned: false,
          ),
          Divider(
            color: context.colors.inputBorder,
          ),
          DetailRow(
            title: 'Solution Function',
            value: solutionFunction,
            isValueAligned: false,
          ),
          Divider(
            color: context.colors.inputBorder,
          ),
          DetailRow(
            title: 'Subject',
            value: subject,
            isValueAligned: false,
          ),

          const SizedBox(height: 8),

          // View Receipt Button
          GestureDetector(
            onTap: onViewReceipt,
            child: Text(
              'View Receipt',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.colors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
