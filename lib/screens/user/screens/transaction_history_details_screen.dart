import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/payment_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:feedback_work/screens/user/widgets/feedback_card.dart';
import 'package:feedback_work/screens/user/widgets/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryDetailsScreen extends ConsumerStatefulWidget {
  const TransactionHistoryDetailsScreen({super.key, required this.currentUser});

  final UserModel currentUser;

  @override
  ConsumerState<TransactionHistoryDetailsScreen> createState() =>
      _TransactionHistoryDetailsScreenState();
}

class _TransactionHistoryDetailsScreenState
    extends ConsumerState<TransactionHistoryDetailsScreen> {
  List<String> descriptions = [
    'Total feedback\nrequested',
    'Total feedback\naccepted/applied',
    'Total feedback\nprovided as free',
    'Total feedback\nprovided at cost'
  ];

  String selectedDescription = 'Total feedback\nrequested';
  int selectedPaymentTypeIndex = 0;

  List<PaymentModel>? providedByMeForFree;
  List<PaymentModel>? providedByMeAtCost;
  List<PaymentModel>? requestedByMe;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(paymentProvider.notifier).fetchMyPayments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<double> prices = [
      0,
      widget.currentUser.totalFeedbackAcceptedAmount ?? 0,
      widget.currentUser.totalFeedbackProvidedFreeAmount ?? 0,
      widget.currentUser.totalFeedbackProvidedAtCostAmount ?? 0,
    ];
    final paymentFetchingState = ref.watch(paymentProvider);
    ref.listen(paymentProvider, (_, newState) {
      if (newState.fetchPaymentState == AsyncState.success) {
        providedByMeForFree = newState.providedByMePayments
                ?.where((p) => p.feedbackCost == 0)
                .toList() ??
            [];
        providedByMeAtCost = newState.providedByMePayments
                ?.where((p) => p.feedbackCost != 0)
                .toList() ??
            [];
        requestedByMe = newState.requestedByMePayments ?? [];
      }
    });
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Builder(builder: (context) {
        if (paymentFetchingState.fetchPaymentState == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (paymentFetchingState.fetchPaymentState ==
            AsyncState.failure) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Padding(
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
                      amount: prices[index].toString(),
                      description: descriptions[index],
                      isSelected: selectedPaymentTypeIndex == index,
                      onTap: () {
                        setState(() {
                          selectedPaymentTypeIndex = index;
                        });
                      },
                    ),
                    separatorBuilder: (context, index) => 8.pw,
                  ),
                ),
                16.ph,
                if (selectedPaymentTypeIndex == 1) ...[
                  if (requestedByMe!.isNotEmpty) ...[
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ReceiptCard(
                            name:
                                "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
                            date: "${requestedByMe![index].payAt}",
                            profileImageUrl: "${widget.currentUser.avaterUrl}",
                            project:
                                "${requestedByMe![index].feedback?.project?.projectName}",
                            problem:
                                "${requestedByMe![index].feedback?.project?.problemName}",
                            solution:
                                "${requestedByMe![index].feedback?.project?.solutionName}",
                            solutionFunction:
                                "${requestedByMe![index].feedback?.project?.solutionFunctionName}",
                            subject:
                                "${requestedByMe![index].feedback?.project?.projectName}",
                            amount: "${requestedByMe![index].totalAmount}",
                            onViewReceipt: () {
                              context.pushNamed(
                                Routes.feedbackReceipt,
                                extra: requestedByMe?[index],
                              );
                            }),
                        separatorBuilder: (_, __) => 8.ph,
                        itemCount: requestedByMe?.length ?? 0,
                      ),
                    ),
                  ],
                  if (requestedByMe!.isEmpty) ...[
                    const Center(
                      child: Text('There is no available payments'),
                    )
                  ]
                ],
                if (selectedPaymentTypeIndex == 2) ...[
                  if (providedByMeForFree!.isNotEmpty) ...[
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
                              context.pushNamed(
                                Routes.feedbackReceipt,
                                extra: providedByMeForFree?[index],
                              );
                            }),
                        separatorBuilder: (_, __) => 8.ph,
                        itemCount: providedByMeForFree?.length ?? 0,
                      ),
                    ),
                  ],
                  if (providedByMeForFree!.isEmpty) ...[
                    const Center(
                      child: Text("There is no available payments"),
                    )
                  ]
                ],
                if (selectedPaymentTypeIndex == 3) ...[
                  if (providedByMeAtCost!.isNotEmpty) ...[
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
                              context.pushNamed(
                                Routes.feedbackReceipt,
                                extra: providedByMeAtCost?[index],
                              );
                            }),
                        separatorBuilder: (_, __) => 8.ph,
                        itemCount: providedByMeAtCost?.length ?? 0,
                      ),
                    ),
                  ],
                  if (providedByMeAtCost!.isEmpty) ...[
                    const Center(
                      child: Text('There is no available payments'),
                    )
                  ]
                ],
              ],
            ),
          );
        }
      }),
    );
  }
}
