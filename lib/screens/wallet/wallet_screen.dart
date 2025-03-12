import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/ui/widgets/app_dropdown.dart';
import 'package:feedback_work/screens/wallet/widgets/add_withdraw_method_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              BalanceCard(
                balance: 10.54,
              ),
              SizedBox(height: 16),
              LastWithdrawalCard(
                amount: 30.02,
                destination: 'Direct to Local Bank - Account ending in 4242',
                date: 'Aug 27, 2024',
              ),
              SizedBox(height: 16),
              WithdrawalMethodsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.pureWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Balance',
                style: Theme.of(context).textTheme.bodySmall),
            8.ph,
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: context.colors.primaryBlue,
                  ),
            ),
            16.ph,
            AppButton.filled(
              label: 'Withdraw Now',
              onTap: () {
                context.pushNamed(Routes.withdraw);
              },
              verticalPadding: 8.h,
            ),
          ],
        ),
      ),
    );
  }
}

class LastWithdrawalCard extends StatelessWidget {
  final double amount;
  final String destination;
  final String date;

  const LastWithdrawalCard({
    super.key,
    required this.amount,
    required this.destination,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.pureWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Withdrawal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${amount.toStringAsFixed(2)} to $destination',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'View transaction history',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primaryBlue,
                    decoration: TextDecoration.underline,
                    decorationColor: context.colors.primaryBlue,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawalMethodsSection extends StatelessWidget {
  const WithdrawalMethodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.pureWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Withdrawal Methods',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          AppButton.outlined(
            label: 'Add Method',
            onTap: () {
              showWithdrawalMethodsBottomSheet(context);
            },
            borderColor: context.colors.primaryBlue,
          ),
          const SizedBox(height: 16),
          const PaymentMethodItem(
            icon: 'P',
            iconBackgroundColor: Colors.blue,
            iconTextColor: Colors.white,
            name: 'Paypal',
            accountNumber: '12345678',
          ),
          const PaymentMethodItem(
            icon: 'Z',
            iconBackgroundColor: Colors.purple,
            iconTextColor: Colors.white,
            name: 'Zelle Account',
            accountNumber: '1234567',
          ),
          const PaymentMethodItem(
            icon: '\$',
            iconBackgroundColor: Colors.green,
            iconTextColor: Colors.white,
            name: 'Cash App',
            accountNumber: '1234567',
          ),
          const PaymentMethodItem(
            icon: 'P',
            iconBackgroundColor: Colors.white,
            iconTextColor: Colors.black,
            name: 'Payoneer Payment Card',
            accountNumber: '12345678',
            showBorder: true,
          ),
          const PaymentMethodItem(
            icon: '🏛',
            iconBackgroundColor: Colors.grey,
            iconTextColor: Colors.black,
            name: 'Direct to Local Bank (EUR)',
            accountNumber: 'account ending in 4242',
          ),
          const PaymentMethodItem(
            icon: '🏛',
            iconBackgroundColor: Colors.grey,
            iconTextColor: Colors.black,
            name: 'Wire Transfer',
            accountNumber: '1234567',
          ),
          const PaymentMethodItem(
            icon: '🏛',
            iconBackgroundColor: Colors.grey,
            iconTextColor: Colors.black,
            name: 'Bank account ending in 4242',
            accountNumber: '',
          ),
        ],
      ),
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final String icon;
  final Color iconBackgroundColor;
  final Color iconTextColor;
  final String name;
  final String accountNumber;
  final bool showBorder;

  const PaymentMethodItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconTextColor,
    required this.name,
    required this.accountNumber,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border:
                    showBorder ? Border.all(color: Colors.grey.shade300) : null,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: 18,
                    color: iconTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (accountNumber.isNotEmpty)
                    Text(
                      accountNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            AppDropdown(
              button: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.inputBorder,
                  ),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.black45,
                ),
              ),
              itemWidth: 150.w,
              overlayHeight: 200.h,
              overlayAlignment: Alignment.centerRight,
              items: const [
                AppDropdownItem(value: 'Edit', label: 'Edit'),
                AppDropdownItem(value: 'Remove', label: 'Remove'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
