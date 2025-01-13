import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/screens/user/widgets/details_row.dart';
import 'package:feedback_work/screens/user/widgets/feedback_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackReceiptScreen extends StatelessWidget {
  const FeedbackReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("Feedback Receipt"),
      ),
      body: Column(
        children: [
          const FeedbackReceiptHeaderSection(
            feedbackRequestDate: "feedbackRequestDate",
            feedbackProvidedDate: "feedbackProvidedDate",
            providerName: "providerName",
            requesterName: "requesterName",
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("Problems"),
                      ),
                      Expanded(
                        child: Center(child: Text("Quantity")),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: context.colors.errorRed.withValues(
                      alpha: 0.3,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text("Prblem Name:"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                            "Requested Feedback: Need help for cleaning hard surface"),
                      ),
                      Expanded(
                        child: Center(child: Text("1")),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: context.colors.errorRed.withValues(
                      alpha: 0.3,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("Total Problems"),
                      ),
                      Expanded(
                        child: Center(child: Text("1")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
