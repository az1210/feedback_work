import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/screens/user/widgets/feedback_card.dart';
import 'package:feedback_work/screens/user/widgets/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryDetailsScreen extends StatefulWidget {
  const TransactionHistoryDetailsScreen({super.key});

  @override
  State<TransactionHistoryDetailsScreen> createState() =>
      _TransactionHistoryDetailsScreenState();
}

class _TransactionHistoryDetailsScreenState
    extends State<TransactionHistoryDetailsScreen> {
  List<String> descriptions = [
    'Total feedback\nrequested',
    'Total feedback\naccepted/applied',
    'Total feedback\nprovided as free',
    'Total feedback\nprovided at cost'
  ];
  String selectedDescription = 'Total feedback\nrequested';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
              child: ListView.separated(
                itemCount: descriptions.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => FeedbackCard(
                  amount: r"$200",
                  description: descriptions[index],
                  isSelected: selectedDescription == descriptions[index],
                  onTap: () {
                    setState(() {
                      selectedDescription = descriptions[index];
                    });
                  },
                ),
                separatorBuilder: (context, index) => 8.pw,
              ),
            ),
            16.ph,
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ReceiptCard(
                    name: "name",
                    date: "date",
                    profileImageUrl: "profileImageUrl",
                    project: "project",
                    problem: "problem",
                    solution: "solution",
                    solutionFunction: "solutionFunction",
                    subject: "subject",
                    amount: "amount",
                    onViewReceipt: () {
                      context.pushNamed(Routes.feedbackReceipt);
                    }),
                separatorBuilder: (_, __) => 8.ph,
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
