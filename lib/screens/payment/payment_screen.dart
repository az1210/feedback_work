import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/payment_model.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.feedback,
  });
  final FeedbackModel feedback;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String? selectedPaymentMethod;
  String selectedBonus = 'No Bonus';
  bool saveInformation = false;
  String? bonus;
  List<String>? availablePaymentMethods;

  @override
  void initState() {
    Future.microtask(() {
      Log.info(widget.feedback.requestFeedback!.cost!.round().toString());
      ref.read(paymentProvider.notifier).getAvailablePaymentMethods(
            amount: widget.feedback.requestFeedback!.cost!,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final paymentNotifier = ref.read(paymentProvider.notifier);
    ref.listen(paymentProvider, (_, newState) {
      if (newState.paymentMethodState == AsyncState.success) {
        availablePaymentMethods =
            newState.paymentMethods!.where((p) => p != 'link').toList();
      }
    });
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 64.h,
              child: Builder(builder: (context) {
                if (paymentState.paymentMethodState == AsyncState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (paymentState.paymentMethodState ==
                    AsyncState.failure) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                } else if (availablePaymentMethods != null &&
                    availablePaymentMethods!.isNotEmpty) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => PaymentMethod(
                      name: availablePaymentMethods![index],
                      onSelectPaymentMethod: (val) {
                        setState(() {
                          selectedPaymentMethod = val;
                        });
                      },
                      selectedPaymentMethod: selectedPaymentMethod ?? '',
                    ),
                    separatorBuilder: (_, __) => 8.pw,
                    itemCount: availablePaymentMethods?.length ?? 0,
                  );
                } else {
                  return const Center(
                    child: Text("No payment method available."),
                  );
                }
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Bonus',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBonusOption(
                    amount: 'No Bonus',
                    onTap: () {
                      setState(() {
                        selectedBonus = 'No Bonuse';
                      });
                    },
                  ),
                  _buildBonusOption(
                    amount: '\$1.00',
                    onTap: () {
                      setState(() {
                        selectedBonus = '\$1.00';
                        bonus = '1';
                      });
                    },
                  ),
                  _buildBonusOption(
                    amount: '\$2.00',
                    onTap: () {
                      setState(() {
                        selectedBonus = '\$2.00';
                        bonus = '2';
                      });
                    },
                  ),
                  _buildBonusOption(
                    amount: 'Custom',
                    onTap: () {
                      setState(() {
                        selectedBonus = 'Custom';
                      });
                    },
                  ),
                ],
              ),
            ),
            if (selectedBonus == 'Custom') ...[
              8.ph,
              TextField(
                decoration: context.inputDecor.outlinedInputDecor(
                  hint: 'Input Bonus',
                  borderRadius: BorderRadius.circular(8.r),
                  fillColor: context.colors.transparent,
                  focusColor: context.colors.darkGrey,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    bonus = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${widget.feedback.requestFeedback!.cost}'),
              ],
            ),
            4.ph,
            Divider(
              color: context.colors.darkGrey,
            ),
            4.ph,
            if (bonus != null && bonus!.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bonus'),
                  Text('\$$bonus'),
                ],
              ),
              4.ph,
              Divider(
                color: context.colors.darkGrey,
              ),
              4.ph,
            ],
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax and Fees'),
                Text('\$0.0'),
              ],
            ),
            4.ph,
            Divider(
              color: context.colors.darkGrey,
            ),
            4.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${widget.feedback.requestFeedback!.cost! + double.parse(bonus ?? '0')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton.filled(
                    isLoading:
                        paymentState.createPaymentState == AsyncState.loading,
                    label: "Submit",
                    labelTextStyle:
                        Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: context.colors.pureWhite,
                              fontWeight: FontWeight.bold,
                            ),
                    onTap: selectedPaymentMethod == null
                        ? () {
                            showToast(message: 'Select Payment Method');
                          }
                        : () async {
                            await paymentNotifier.createPaymentIntent(
                              amount: (widget.feedback.requestFeedback!.cost! +
                                      double.parse(bonus ?? '0'))
                                  .round()
                                  .toString(),
                              paymentMethod: selectedPaymentMethod ?? 'usd',
                            );
                            await paymentNotifier.initializePaymentSheet(
                              amount: widget.feedback.requestFeedback!.cost!
                                  .round()
                                  .toString(),
                            );
                            await paymentNotifier.presentPaymentSheet(
                              paymentModel: PaymentModel(
                                feedbackId: widget.feedback.id,
                                feedbackCost:
                                    widget.feedback.requestFeedback?.cost ?? 0,
                                bonus: double.parse(bonus ?? '0'),
                              ),
                            );
                            // paymentSheetInitialization(
                            //     amount: widget.feedback.requestFeedback!.cost!
                            //         .round()
                            //         .toString(),
                            //     currency: 'USD');
                            // ref.read(feedbackProvider.notifier).appliedFeedback(
                            //       feedback: feedback,
                            //       userId: feedback.projectOwnerId!,
                            //       callback: () {
                            //         context.goNamed(Routes.feedback);
                            //       },
                            //     );
                          },
                    height: 52.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusOption({
    required String amount,
    required void Function() onTap,
  }) {
    bool isSelected = selectedBonus == amount;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? context.colors.primaryBlue : Colors.grey[300]!,
            ),
          ),
          child: Text(
            amount,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatefulWidget {
  final String name;
  final String selectedPaymentMethod;
  final Widget? icon;
  final void Function(String) onSelectPaymentMethod;
  const PaymentMethod({
    super.key,
    required this.name,
    this.icon,
    required this.onSelectPaymentMethod,
    required this.selectedPaymentMethod,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selectedPaymentMethod == widget.name;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = true;
          widget.onSelectPaymentMethod(widget.name);
        });
      },
      child: Container(
        width: 86.w,
        height: 64.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
            ],
            Text(
              widget.name.toTitleCase(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isSelected
                        ? context.colors.primaryBlue
                        : context.colors.darkGrey,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
