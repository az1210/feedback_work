import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/screens/user/widgets/transaction_history_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Transaction",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                      )),
                  Expanded(
                      child: Center(
                          child: Text(
                    "Quantity",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ))),
                  Expanded(
                      child: Center(
                          child: Text(
                    "Price",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ))),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  TransactionHistoryOverviewCard(
                    index: 0,
                    price: 50,
                    quantity: 5,
                    title: "Total feedback requested",
                    onTap: () {
                      context.pushNamed(Routes.transactionHistoryDetails);
                    },
                  ),
                  TransactionHistoryOverviewCard(
                    index: 1,
                    price: 50,
                    quantity: 5,
                    title: "Total feedback accepted/applie",
                    onTap: () {
                      context.pushNamed(Routes.transactionHistoryDetails);
                    },
                  ),
                  TransactionHistoryOverviewCard(
                    index: 2,
                    price: 50,
                    quantity: 5,
                    title: "Total feedback provided free",
                    onTap: () {
                      context.pushNamed(Routes.transactionHistoryDetails);
                    },
                  ),
                  TransactionHistoryOverviewCard(
                    index: 3,
                    price: 50,
                    quantity: 5,
                    title: "Total feedback provided at cost",
                    onTap: () {
                      context.pushNamed(Routes.transactionHistoryDetails);
                    },
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
