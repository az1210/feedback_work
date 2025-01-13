import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionHistoryOverviewCard extends StatelessWidget {
  const TransactionHistoryOverviewCard({
    super.key,
    required this.index,
    required this.title,
    required this.quantity,
    required this.price,
    required this.onTap,
  });

  final int index;
  final String title;
  final int quantity;
  final double price;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? context.colors.primaryBlue.withValues(
                alpha: 0.1,
              )
            : context.colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.colors.primaryBlue,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "$quantity",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "\$$price",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
