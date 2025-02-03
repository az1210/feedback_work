// import 'package:feedback_work/core/constants/api_endpoints.dart';
// import 'package:feedback_work/core/utils/network/rest_client/rest_client.dart';
// import 'package:feedback_work/core/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentService {
//   final RestClient _restClient;

//   PaymentService(this._restClient);

//   Future<Map<String, dynamic>?> createPaymentIntent({
//     required String amount,
//     String currency = 'USD',
//     required String stripeSecretKey,
//   }) async {
//     try {
//       final response = await _restClient.post(
//         APIType.private,
//         ApiEndpoints.stripePaymentIntent,
//         {
//           'amount': (int.parse(amount) * 100).toString(),
//           'currency': currency,
//           'payment_method_types[]': 'card'
//         },
//         headers: {
//           'Authorization': "Bearer $stripeSecretKey",
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//       );

//       return response.data;
//     } catch (e, stackTrace) {
//       Log.error(e.toString());
//       Log.error(stackTrace.toString());
//       return null;
//     }
//   }

//   Future<void> initializePaymentSheet({
//     required String amount,
//     String currency = 'USD',
//     required String stripeSecretKey,
//   }) async {
//     try {
//       final paymentIntent = await createPaymentIntent(
//         amount: amount,
//         currency: currency,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (paymentIntent != null) {
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             allowsDelayedPaymentMethods: true,
//             paymentIntentClientSecret: paymentIntent['client_secret'],
//             style: ThemeMode.system,
//             merchantDisplayName: 'Feedback Work',
//           ),
//         );
//       }
//     } catch (e, stackTrace) {
//       Log.error(e.toString());
//       Log.error(stackTrace.toString());
//     }
//   }

//   Future<void> presentPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//     } on StripeException catch (error) {
//       Log.error(error.toString());
//     } catch (e, stackTrace) {
//       Log.error(e.toString());
//       Log.error(stackTrace.toString());
//     }
//   }
// }
