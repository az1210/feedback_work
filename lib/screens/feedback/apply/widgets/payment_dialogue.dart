import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/network/rest_client/rest_client.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/payment_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentDialogue extends ConsumerStatefulWidget {
  final FeedbackModel feedback;

  const PaymentDialogue({
    super.key,
    required this.feedback,
  });

  @override
  ConsumerState<PaymentDialogue> createState() => _PaymentDialogueState();
}

class _PaymentDialogueState extends ConsumerState<PaymentDialogue> {
  // String stripeSecretKey = '';

  // Map<String, dynamic>? intentPaymentData;

  // showPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((val) {
  //       intentPaymentData = null;
  //     }).onError((e, stackTrace) {
  //       Log.error(e.toString());
  //       Log.error(stackTrace.toString());
  //     });
  //   } on StripeException catch (error) {
  //     Log.error(error.toString());
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //   }
  // }

  // makeIntentForPayment(
  //     {required String amount, String currency = 'USD'}) async {
  //   try {
  //     Map<String, dynamic>? paymentInfo = {
  //       'amount': (int.parse(amount) * 100).toString(),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };

  //     var responseFromStripeAPI = await http.post(
  //         Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         body: paymentInfo,
  //         headers: {
  //           'AUthorization': "Bearer $stripeSecretKey",
  //           'Content-Type': 'application/x-www-Form-Urlencoded'
  //         });

  //     return jsonDecode(responseFromStripeAPI.body);
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //   }
  // }

  // paymentSheetInitialization(
  //     {required String amount, String currency = 'USD'}) async {
  //   try {
  //     intentPaymentData =
  //         await makeIntentForPayment(amount: amount, currency: currency);
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //       allowsDelayedPaymentMethods: true,
  //       paymentIntentClientSecret: intentPaymentData!['client_secret'],
  //       style: ThemeMode.system,
  //       merchantDisplayName: 'Feedback Work',
  //     ))
  //         .then((val) {
  //       Log.info(val.toString());
  //     });
  //     showPaymentSheet();
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //   }
  // }

  @override
  void initState() {
    Future.microtask(() async {
      ref.read(stripeSecretKeyProvider.notifier).state =
          await ref.read(paymentProvider.notifier).stripeSecretKey() ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentNotifier = ref.read(paymentProvider.notifier);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apply Feedback',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "By accepting or applying this feedback, you are going to pay ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\$${widget.feedback.requestFeedback!.cost} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: "for the effort of ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "${widget.feedback.project!.owner!.firstName} ${widget.feedback.project!.owner!.lastName} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text:
                        "who provides you the feedback. The money will be deducted from your account to provide ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "${widget.feedback.project!.owner!.firstName} ${widget.feedback.project!.owner!.lastName} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: "who provided you the feedback.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton.outlined(
                    label: "Cancel",
                    onTap: () {
                      context.pop();
                    },
                    borderColor: context.colors.primaryBlue,
                  ),
                ),
                16.pw,
                Expanded(
                  child: AppButton.filled(
                    label: "Confirm Payment",
                    onTap: () async {
                      context.pushNamed(Routes.payment, extra: widget.feedback);
                      // await paymentNotifier.initializePaymentSheet(
                      //   amount: widget.feedback.requestFeedback!.cost!
                      //       .round()
                      //       .toString(),
                      // );
                      // await paymentNotifier.presentPaymentSheet();
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
