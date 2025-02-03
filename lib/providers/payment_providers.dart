// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/network/rest_client/api_options.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:feedback_work/core/constants/api_endpoints.dart';
import 'package:feedback_work/core/utils/network/rest_client/rest_client.dart';
import 'package:feedback_work/core/utils/utils.dart';

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);

class PaymentNotifier extends Notifier<PaymentState> {
  @override
  PaymentState build() {
    return PaymentState(state: AsyncState.initial);
  }

  Future<Map<String, dynamic>?> createPaymentIntent({
    required String amount,
    String currency = 'USD',
    // required String stripeSecretKey,
  }) async {
    try {
      final restClient = ref.read(stripePaymentAPIProvider);
      final response = await restClient.post(
        ApiAccessType.protected,
        ApiEndpoints.stripePaymentIntent,
        {
          'amount': (int.parse(amount) * 100).toString(),
          'currency': currency,
          'payment_method_types[]': 'card'
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      return response.data;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }

  Future<void> initializePaymentSheet({
    required String amount,
    String currency = 'USD',
  }) async {
    try {
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      if (paymentIntent != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            allowsDelayedPaymentMethods: true,
            paymentIntentClientSecret: paymentIntent['client_secret'],
            style: ThemeMode.system,
            merchantDisplayName: 'Feedback Work',
          ),
        );
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (error) {
      Log.error(error.toString());
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<String?> stripePublishableKey({void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      String key = '';
      state = state.copyWith(state: AsyncState.loading);
      final docRef = await firestore
          .collection(FirebaseConstants.apiKeyCollection)
          .doc('stripePublishableKey')
          .get();
      if (docRef.exists) {
        key = docRef.data()?['stripePublishableKey'] ?? '';
      }

      // await firestore
      //     .collection(FirebaseConstants.apiKeyCollection)
      //     .doc('stripePublishableKey')
      //     .set({
      //   'stripePublishableKey':
      //       'pk_test_51QnJuXG6nVf1Zo6aiQILYmJGg9OULLE5Tumi2Dcnz1dIEoHOhEZVu6fC7GXyDkjipMFSy1idpkoqZy5lQ9Nl8OCI00cx1cvFoV'
      // });

      callback?.call();
      state = state.copyWith(state: AsyncState.success);
      return key;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }

  Future<String?> stripeSecretKey({void Function()? callback}) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      String key = '';
      state = state.copyWith(state: AsyncState.loading);
      final docRef = await firestore
          .collection(FirebaseConstants.apiKeyCollection)
          .doc('stripeSecretKey')
          .get();
      if (docRef.exists) {
        key = docRef.data()?['stripeSecretKey'] ?? '';
      }
      // await firestore
      //     .collection(FirebaseConstants.apiKeyCollection)
      //     .doc('stripeSecretKey')
      //     .set({
      //   'stripeSecretKey':
      //       'sk_test_51QnJuXG6nVf1Zo6aTnLslcX2oKXJxQ5WuIGmqSYTvoyfwFCcSajOzPwj6nJKn6VdihYVTedtmpUFdW5tmBP3dglv00VazxU0Hm'
      // });

      callback?.call();
      state = state.copyWith(state: AsyncState.success);
      return key;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }
}

class PaymentState {
  final AsyncState? state;

  PaymentState({this.state});

  PaymentState copyWith({
    AsyncState? state,
  }) {
    return PaymentState(
      state: state ?? this.state,
    );
  }
}
