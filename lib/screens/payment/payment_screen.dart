import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  String selectedPaymentMethod = 'Paypal';
  String selectedBonus = 'No Bonus';
  bool saveInformation = false;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  List<String>? availablePaymentMethods;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(paymentProvider.notifier).getAvailablePaymentMethods(
          amount: widget.feedback.requestFeedback?.cost.toString() ?? '0');
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
                      selectedPaymentMethod: selectedPaymentMethod,
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
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       _buildPaymentOption(
            //         'Paypal',
            //         SvgPicture.asset(AppAssets.svgs.paypal),
            //       ),
            //       const SizedBox(width: 8),
            //       _buildPaymentOption(
            //         'Card',
            //         const Icon(Icons.credit_card),
            //       ),
            //       const SizedBox(width: 8),
            //       _buildPaymentOption(
            //           'EPS',
            //           SvgPicture.asset(
            //             AppAssets.svgs.eps,
            //           )),
            //       const SizedBox(width: 8),
            //       _buildPaymentOption(
            //           'Giropay',
            //           SvgPicture.asset(
            //             AppAssets.svgs.giropay,
            //           )),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            // TextFormField(
            //   controller: cardNumberController,
            //   decoration: InputDecoration(
            //     labelText: 'Card number',
            //     border: const OutlineInputBorder(),
            //     suffixIcon: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         SvgPicture.asset(AppAssets.svgs.cards),
            //         10.pw,
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         controller: expirationController,
            //         decoration: const InputDecoration(
            //           labelText: 'Expiration date',
            //           hintText: 'MM / YY',
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: TextFormField(
            //         controller: cvcController,
            //         decoration: const InputDecoration(
            //           labelText: 'Security code',
            //           hintText: 'CVC',
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: DropdownMenu(
            //         hintText: 'Country',
            //         dropdownMenuEntries: ['United States'].map((String value) {
            //           return DropdownMenuEntry<String>(
            //             value: value,
            //             label: value,
            //           );
            //         }).toList(),
            //         onSelected: (value) {},
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: TextFormField(
            //         controller: postalCodeController,
            //         decoration: const InputDecoration(
            //           labelText: 'Postal code',
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Switch(
            //       value: saveInformation,
            //       activeColor: context.colors.primaryBlue,
            //       onChanged: (value) {
            //         setState(() {
            //           saveInformation = value;
            //         });
            //       },
            //     ),
            //     8.pw,
            //     Expanded(
            //       child: Text(
            //         'Save information to pay faster next time',
            //         style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),
            const Text(
              'Add Bonus',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBonusOption('No Bonus'),
                  _buildBonusOption('\$1.00'),
                  _buildBonusOption('\$2.00'),
                  _buildBonusOption('Custom'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal'),
                Text('\$1.0'),
              ],
            ),
            4.ph,
            Divider(
              color: context.colors.darkGrey,
            ),
            4.ph,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax and Fees'),
                Text('\$0.5'),
              ],
            ),
            4.ph,
            Divider(
              color: context.colors.darkGrey,
            ),
            4.ph,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$1.5',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    onTap: () async {
                      await paymentNotifier.createPaymentIntent(
                        amount: widget.feedback.requestFeedback!.cost!
                            .round()
                            .toString(),
                        paymentMethod: selectedPaymentMethod,
                      );
                      await paymentNotifier.initializePaymentSheet(
                        amount: widget.feedback.requestFeedback!.cost!
                            .round()
                            .toString(),
                      );
                      await paymentNotifier.presentPaymentSheet();
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

  Widget _buildPaymentOption(String title, Widget icon) {
    bool isSelected = selectedPaymentMethod == title;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
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
            icon,
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isSelected
                        ? context.colors.primaryBlue
                        : context.colors.darkGrey,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBonusOption(String amount) {
    bool isSelected = selectedBonus == amount;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedBonus = amount;
          });
        },
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
