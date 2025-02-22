// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/network/rest_client/api_options.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/models/post_payment_intent_response_model.dart';
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
    return PaymentState(createPaymentState: AsyncState.initial);
  }

  Future<void> getAvailablePaymentMethods({
    required String amount,
    String currency = 'USD',
    // required String stripeSecretKey,
  }) async {
    try {
      state = state.copyWith(paymentMethodState: AsyncState.loading);
      final restClient = ref.read(stripePaymentAPIProvider);
      final response = await restClient.post(
        ApiAccessType.protected,
        ApiEndpoints.stripePaymentIntent,
        {
          // 'amount': (int.parse(amount) * 100).toString(),
          'amount': "100",
          'currency': currency,
          // 'payment_method_types[]': 'card'
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      state = state.copyWith(
          paymentMethodState: AsyncState.success,
          paymentMethods:
              (response.data['payment_method_types'] as List<dynamic>)
                  .map((p) => p.toString())
                  .toList());
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(paymentMethodState: AsyncState.failure);
    }
  }

  Future<void> createPaymentIntent({
    required String amount,
    String currency = 'USD',
    String paymentMethod = 'card',
    // required String stripeSecretKey,
  }) async {
    try {
      state = state.copyWith(createPaymentState: AsyncState.loading);
      final restClient = ref.read(stripePaymentAPIProvider);
      final response = await restClient.post(
        ApiAccessType.protected,
        ApiEndpoints.stripePaymentIntent,
        {
          // 'amount': (int.parse(amount) * 100).toString(),
          'amount': "100",
          'currency': currency,
          'payment_method_types[]': paymentMethod
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      state = state.copyWith(
          createPaymentState: AsyncState.success,
          paymentIntentResponseModel:
              PostPaymentIntentResponseModel.fromJson(response.data));
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(createPaymentState: AsyncState.failure);
    }
  }

  Future<void> initializePaymentSheet({
    required String amount,
    String currency = 'USD',
  }) async {
    try {
      createPaymentIntent(
        // amount: amount,
        amount: '100',
        currency: currency,
      );

      if (state.paymentIntentResponseModel != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            allowsDelayedPaymentMethods: true,
            paymentIntentClientSecret:
                state.paymentIntentResponseModel!.clientSecret,
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
      if (error.error.code == FailureCode.Canceled) {
        showToast(message: "Payment Canceled");
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<String?> stripePublishableKey({void Function()? callback}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      String key = '';
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
      return key;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }

  Future<String?> stripeSecretKey({void Function()? callback}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);

    try {
      String key = '';
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
      return key;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }
}

class PaymentState {
  final AsyncState? createPaymentState;
  final AsyncState? paymentMethodState;
  final PostPaymentIntentResponseModel? paymentIntentResponseModel;
  final List<String>? paymentMethods;

  PaymentState({
    this.createPaymentState,
    this.paymentMethodState,
    this.paymentIntentResponseModel,
    this.paymentMethods,
  });

  PaymentState copyWith({
    AsyncState? createPaymentState,
    AsyncState? paymentMethodState,
    PostPaymentIntentResponseModel? paymentIntentResponseModel,
    List<String>? paymentMethods,
  }) {
    return PaymentState(
      createPaymentState: createPaymentState ?? this.createPaymentState,
      paymentMethodState: paymentMethodState ?? this.paymentMethodState,
      paymentIntentResponseModel:
          paymentIntentResponseModel ?? this.paymentIntentResponseModel,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
