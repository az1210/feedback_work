import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/models/payment_model.dart';
import 'package:feedback_work/screens/user/widgets/details_row.dart';
import 'package:feedback_work/screens/user/widgets/feedback_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackReceiptScreen extends StatelessWidget {
  const FeedbackReceiptScreen({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("Feedback Receipt"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FeedbackReceiptHeaderSection(
              feedbackRequestDate:
                  "${payment.feedback?.requestFeedback?.requestedAt}",
              feedbackProvidedDate:
                  "${payment.feedback?.provideFeedback?.providedAt}",
              providerName: "${payment.providerName}",
              requesterName: "${payment.requestedByUserName}",
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
                    child: Row(
                      children: [
                        Text("${payment.feedback?.project?.problemName}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                              "Requested Feedback: ${payment.feedback?.requestFeedback?.message?.message.toString()}"),
                        ),
                        const Expanded(
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
                          child: Text("Solutions"),
                        ),
                        Expanded(
                          child: Center(child: Text("Quantity")),
                        ),
                        Expanded(
                          child: Center(child: Text("Price")),
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
                      color: context.colors.successGreen.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text("${payment.feedback?.project?.solutionName}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                              "Provide Feedback: ${payment.feedback?.project?.solutionName}"),
                        ),
                        const Expanded(
                          child: Center(child: Text("1")),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                                  "\$${payment.feedback?.requestFeedback?.cost}")),
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
                      color: context.colors.successGreen.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Total Solutions"),
                        ),
                        const Expanded(
                          child: Center(child: Text("1")),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                                  "\$${payment.feedback?.requestFeedback?.cost}")),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Total Price"),
                        ),
                        const Expanded(
                          child: Center(child: Text("")),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                                  "\$${payment.feedback?.requestFeedback?.cost}")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                          child: Text("Solutions Functions"),
                        ),
                        Expanded(
                          child: Center(child: Text("Quantity")),
                        ),
                        Expanded(
                          child: Center(child: Text("Price")),
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
                      color: context.colors.successGreen.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                            "${payment.feedback?.project?.solutionFunctionName}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                              "Apply Feedback: ${payment.feedback?.requestFeedback?.message?.message.toString()}"),
                        ),
                        const Expanded(
                          child: Center(child: Text("1")),
                        ),
                        const Expanded(
                          child: Center(child: Text("N/A")),
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
                          child: Text("Total Solution Functions"),
                        ),
                        Expanded(
                          child: Center(child: Text("1")),
                        ),
                        Expanded(
                          child: Center(child: Text("")),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Total Price"),
                        ),
                        const Expanded(
                          child: Center(child: Text("")),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                                  "\$${payment.feedback?.requestFeedback?.cost}")),
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
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Tip/Bonus"),
                        ),
                        const Expanded(
                          child: Center(child: Text("")),
                        ),
                        Expanded(
                          child: Center(child: Text("\$${payment.bonus}")),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Grand Total"),
                        ),
                        const Expanded(
                          child: Center(child: Text("")),
                        ),
                        Expanded(
                          child: Center(child: Text("${payment.totalAmount}")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
