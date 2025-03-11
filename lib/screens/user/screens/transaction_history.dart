import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:feedback_work/screens/user/widgets/transaction_history_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({required this.currentUser, super.key});

  final UserModel currentUser;

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  int totalFeedbackAcceptedCount = 0;
  int totalFeedbackProvidedAtFreeCount = 0;
  int totalFeedbackProvidedAtCostCount = 0;
  @override
  void initState() {
    Future.microtask(() async {
      totalFeedbackAcceptedCount = await ref
          .watch(paymentProvider.notifier)
          .getDocumentCount(
              collectionName:
                  FirebaseConstants.totalFeedbackAcceptedTransaction);
      totalFeedbackProvidedAtCostCount = await ref
          .watch(paymentProvider.notifier)
          .getDocumentCount(
              collectionName:
                  FirebaseConstants.totalFeedbackProvidedAtCostTransaction);
      totalFeedbackProvidedAtFreeCount = await ref
          .watch(paymentProvider.notifier)
          .getDocumentCount(
              collectionName:
                  FirebaseConstants.totalFeedbackProvidedFreeTransaction);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Builder(builder: (context) {
        if (paymentState.documentCountState == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (paymentState.documentCountState == AsyncState.failure) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Padding(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                        price: 0,
                        quantity:
                            widget.currentUser.totalFeedbackRequested ?? 0,
                        title: "Total feedback requested",
                        onTap: () {
                          context.pushNamed(
                            Routes.transactionHistoryDetails,
                            extra: widget.currentUser,
                          );
                        },
                      ),
                      TransactionHistoryOverviewCard(
                        index: 1,
                        price:
                            widget.currentUser.totalFeedbackAcceptedAmount ?? 0,
                        quantity: totalFeedbackAcceptedCount,
                        title: "Total feedback accepted/applie",
                        onTap: () {
                          context.pushNamed(
                            Routes.transactionHistoryDetails,
                            extra: widget.currentUser,
                          );
                        },
                      ),
                      TransactionHistoryOverviewCard(
                        index: 2,
                        price: widget
                                .currentUser.totalFeedbackProvidedFreeAmount ??
                            0,
                        quantity: totalFeedbackProvidedAtFreeCount,
                        title: "Total feedback provided free",
                        onTap: () {
                          context.pushNamed(
                            Routes.transactionHistoryDetails,
                            extra: widget.currentUser,
                          );
                        },
                      ),
                      TransactionHistoryOverviewCard(
                        index: 3,
                        price: widget.currentUser
                                .totalFeedbackProvidedAtCostAmount ??
                            0,
                        quantity: totalFeedbackProvidedAtCostCount,
                        title: "Total feedback provided at cost",
                        onTap: () {
                          context.pushNamed(
                            Routes.transactionHistoryDetails,
                            extra: widget.currentUser,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
