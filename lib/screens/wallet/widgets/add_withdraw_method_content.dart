import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showWithdrawalMethodsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return const WithdrawalMethodsBottomSheet();
    },
  );
}

class WithdrawalMethodsBottomSheet extends StatelessWidget {
  const WithdrawalMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // List of withdrawal methods with their details
    final List<Map<String, dynamic>> withdrawalMethods = [
      {
        'icon': 'assets/paypal.png',
        'name': 'Paypal',
        'account': '12345678',
        'fee': 1.0,
        'iconWidget':
            const Icon(Icons.account_balance_wallet, color: Colors.blue),
      },
      {
        'icon': 'assets/zelle.png',
        'name': 'Zelle Account',
        'account': '1234567',
        'fee': 1.0,
        'iconWidget': const Text(
          'Zelle',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      },
      {
        'icon': 'assets/cash_app.png',
        'name': 'Cash App',
        'account': '1234567',
        'fee': 1.0,
        'iconWidget': Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              '\$',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      },
      {
        'icon': 'assets/payoneer.png',
        'name': 'Payoneer Payment Card',
        'account': '12345678',
        'fee': 1.0,
        'iconWidget': const Icon(Icons.credit_card, color: Colors.red),
      },
      {
        'icon': 'assets/local_bank.png',
        'name': 'Direct to Local Bank (EUR)',
        'account': 'account ending in 4242',
        'fee': 1.0,
        'iconWidget': const Icon(Icons.location_on, color: Colors.grey),
      },
      {
        'icon': 'assets/wire_transfer.png',
        'name': 'Wire Transfer',
        'account': '',
        'fee': 1.0,
        'iconWidget': const Icon(Icons.account_balance, color: Colors.grey),
      },
      {
        'icon': 'assets/bank_account.png',
        'name': 'Bank account ending in 4242',
        'account': '',
        'fee': 1.0,
        'iconWidget': const Icon(Icons.account_balance, color: Colors.grey),
        'setup': Routes.setupBankAccount,
      },
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Add Withdrawal Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: withdrawalMethods.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final method = withdrawalMethods[index];
                  return WithdrawalMethodItem(
                    iconWidget: method['iconWidget'],
                    name: method['name'],
                    account: method['account'],
                    fee: method['fee'],
                    onTap: () {
                      context.pushNamed(method['setup']);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class WithdrawalMethodItem extends StatelessWidget {
  final Widget iconWidget;
  final String name;
  final String account;
  final double fee;
  final void Function()? onTap;

  const WithdrawalMethodItem({
    super.key,
    required this.iconWidget,
    required this.name,
    required this.account,
    required this.fee,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 12),
                child: iconWidget,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.isNotEmpty ? '$name - $account' : name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${fee.toStringAsFixed(1)} USD per withdrawal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppButton.outlined(
              label: 'Set Up',
              onTap: onTap,
              borderColor: context.colors.primaryBlue,
              verticalPadding: 6.h,
            ),
          ),
        ],
      ),
    );
  }
}
