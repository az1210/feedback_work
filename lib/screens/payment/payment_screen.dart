import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Paypal';
  String selectedBonus = 'No Bonus';
  bool saveInformation = false;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPaymentOption(
                    'Paypal',
                    SvgPicture.asset(AppAssets.svgs.paypal),
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentOption(
                    'Card',
                    const Icon(Icons.credit_card),
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentOption(
                      'EPS',
                      SvgPicture.asset(
                        AppAssets.svgs.eps,
                      )),
                  const SizedBox(width: 8),
                  _buildPaymentOption(
                      'Giropay',
                      SvgPicture.asset(
                        AppAssets.svgs.giropay,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card number',
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssets.svgs.cards),
                    10.pw,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expirationController,
                    decoration: const InputDecoration(
                      labelText: 'Expiration date',
                      hintText: 'MM / YY',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: cvcController,
                    decoration: const InputDecoration(
                      labelText: 'Security code',
                      hintText: 'CVC',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownMenu(
                    hintText: 'Country',
                    dropdownMenuEntries: ['United States'].map((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                    onSelected: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postal code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: saveInformation,
                  activeColor: context.colors.primaryBlue,
                  onChanged: (value) {
                    setState(() {
                      saveInformation = value;
                    });
                  },
                ),
                8.pw,
                Expanded(
                  child: Text(
                    'Save information to pay faster next time',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                    label: "Submit",
                    labelTextStyle:
                        Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: context.colors.pureWhite,
                              fontWeight: FontWeight.bold,
                            ),
                    onTap: () {},
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
