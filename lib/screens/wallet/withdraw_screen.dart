import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/ui/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final double availableBalance = 10.54;
  final double withdrawalFee = 1.0;
  bool isFixedAmount = true;
  double selectedAmount = 10.0;

  @override
  Widget build(BuildContext context) {
    double totalAmount = selectedAmount - withdrawalFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Now'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Withdraw Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Available Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.pureWhite,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${availableBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.colors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Withdrawal Method
                    const Text(
                      'Withdrawal method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown,
                    AppDropdown(
                      button: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.colors.pureWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Direct to Local Bank (EUR) - account...',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      items: const [
                        AppDropdownDropdownItem(
                          value: 'Direct to Local Bank (EUR)',
                          label: 'Direct to Local Bank (EUR)',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Amount
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Fixed Amount Option
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.pureWhite,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '\$10.00',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Radio<bool>(
                            value: true,
                            groupValue: isFixedAmount,
                            fillColor: WidgetStatePropertyAll(
                                context.colors.primaryBlue),
                            onChanged: (value) {
                              setState(() {
                                isFixedAmount = true;
                                selectedAmount = 10.0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Other Amount Option
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.pureWhite,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Other Amount',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Radio<bool>(
                            value: false,
                            groupValue: isFixedAmount,
                            onChanged: (value) {
                              setState(() {
                                isFixedAmount = false;
                              });
                            },
                            fillColor: WidgetStatePropertyAll(
                              context.colors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isFixedAmount) ...[
                      8.ph,
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: context.colors.pureWhite,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.inputBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.inputBorder,
                            ),
                          ),
                          hintText: 'Enter Amount',
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: context.colors.darkGrey,
                                  ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        onChanged: (value) {
                          if (value == '') {
                            selectedAmount = 0;
                          } else {
                            setState(() {
                              selectedAmount = double.parse(value);
                            });
                          }
                        },
                      ),
                    ],
                    const Divider(),
                    const SizedBox(height: 24),

                    // Withdrawal Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Withdrawal fee (per payment)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '-\$${withdrawalFee.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    label: 'Cancel',
                    onTap: () {},
                    borderColor: context.colors.primaryBlue,
                    verticalPadding: 8.h,
                  ),
                ),
                16.pw,
                Expanded(
                  child: AppButton.filled(
                    label: 'Withdraw Now',
                    onTap: () {},
                    verticalPadding: 8.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
