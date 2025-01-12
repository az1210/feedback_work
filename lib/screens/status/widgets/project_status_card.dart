import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectStatusCard extends StatelessWidget {
  final String title;
  final String problemBefore;
  final String solutionAfter;
  final String functionExecuted;
  final String projectStatus;

  const ProjectStatusCard({
    super.key,
    required this.title,
    required this.problemBefore,
    required this.solutionAfter,
    required this.functionExecuted,
    required this.projectStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            color: context.colors.primaryBlue.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BuildInfoRow(
                    label: 'Problem Existed Before',
                    value: problemBefore,
                    valueColor: context.colors.errorRed),
                const SizedBox(height: 8),
                BuildInfoRow(
                    label: 'Solution Replaced After',
                    value: solutionAfter,
                    valueColor: context.colors.successGreen),
                const SizedBox(height: 8),
                BuildInfoRow(
                    label: 'Solution Function Executed',
                    value: functionExecuted,
                    valueColor: context.colors.successGreen),
                const SizedBox(height: 8),
                BuildInfoRow(
                    label: 'Project Status',
                    value: projectStatus,
                    valueColor: context.colors.primaryBlue),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BuildInfoRow extends StatelessWidget {
  const BuildInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: valueColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
