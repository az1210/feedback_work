import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BankAccountSetupScreen extends StatefulWidget {
  const BankAccountSetupScreen({super.key});

  @override
  State<BankAccountSetupScreen> createState() => _BankAccountSetupScreenState();
}

class _BankAccountSetupScreenState extends State<BankAccountSetupScreen> {
  final _accountHolderController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _confirmAccountNumberController = TextEditingController();
  String? _selectedAccountType;

  final List<String> _accountTypes = [
    'Checking',
    'Savings',
    'Business Checking',
    'Business Savings'
  ];

  @override
  void dispose() {
    _accountHolderController.dispose();
    _routingNumberController.dispose();
    _accountNumberController.dispose();
    _confirmAccountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pureWhite,
      appBar: AppBar(
        title: const Text('Add a bank account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account holder name
              const Text(
                'Account holder name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _accountHolderController,
                decoration: context.inputDecor.outlinedInputDecor(
                  borderRadius: BorderRadius.circular(8),
                  fillColor: context.colors.inputBorder,
                ),
              ),
              const SizedBox(height: 16),

              // Account type
              const Text(
                'Account type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width -
                      32, // Full width minus padding
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  initialSelection: _selectedAccountType,
                  onSelected: (String? value) {
                    setState(() {
                      _selectedAccountType = value;
                    });
                  },
                  dropdownMenuEntries: _accountTypes
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                  textStyle: const TextStyle(fontSize: 14),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: const Color(0xFFF2F3F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  trailingIcon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
              const SizedBox(height: 16),

              // Routing number
              const Text(
                'Routing number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _routingNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: context.inputDecor.outlinedInputDecor(
                  borderRadius: BorderRadius.circular(8),
                  fillColor: context.colors.inputBorder,
                ),
              ),
              const SizedBox(height: 16),

              // Account number
              const Text(
                'Account number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: context.inputDecor.outlinedInputDecor(
                  borderRadius: BorderRadius.circular(8),
                  fillColor: context.colors.inputBorder,
                ),
              ),
              const SizedBox(height: 16),

              // Confirm account number
              const Text(
                'Confirm account number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmAccountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: context.inputDecor.outlinedInputDecor(
                  borderRadius: BorderRadius.circular(8),
                  fillColor: context.colors.inputBorder,
                ),
              ),
              const SizedBox(height: 24),

              // Check image with routing and account numbers
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _routingNumberController.text,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _accountNumberController.text,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '0123',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 1,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          'Routing Number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Account Number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppButton.outlined(
                      label: 'Cancel',
                      onTap: () {},
                      borderColor: context.colors.primaryBlue,
                      verticalPadding: 8.h,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: AppButton.filled(
                      label: 'Add Bank Account',
                      onTap: () {},
                      verticalPadding: 8.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
