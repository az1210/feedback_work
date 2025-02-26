import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/models/payment_model.dart';
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
    required double amount,
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
          'amount': (amount.round() * 100)
              .toString(), // To convert into cents the amount is multiply by 100
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
  }) async {
    try {
      state = state.copyWith(createPaymentState: AsyncState.loading);
      final restClient = ref.read(stripePaymentAPIProvider);
      final response = await restClient.post(
        ApiAccessType.protected,
        ApiEndpoints.stripePaymentIntent,
        {
          'amount': (int.parse(amount) * 100).toString(),
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
        amount: amount,
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

  Future<void> presentPaymentSheet({
    required PaymentModel paymentModel,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      createPayment(
          paymentModel: paymentModel.copyWith(
        transactionId: state.paymentIntentResponseModel!.id,
      ));
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

  Future<void> fetchAllPayments() async {
    state = state.copyWith(fetchPaymentState: AsyncState.loading);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final paymentsSnapshot =
          await firestore.collection(FirebaseConstants.paymentCollection).get();

      final payments = paymentsSnapshot.docs
          .map((c) => PaymentModel.fromMap(c.data()))
          .toList();
      state = state.copyWith(
          payments: payments, fetchPaymentState: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> createPayment(
      {required PaymentModel paymentModel, void Function()? callback}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(createPaymentState: AsyncState.loading);
      await firestore
          .collection(FirebaseConstants.paymentCollection)
          .add(paymentModel.toMap());
      await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(paymentModel.feedbackId)
          .set({'payment': paymentModel.transactionId});
      callback?.call();
      state = state.copyWith(createPaymentState: AsyncState.success);
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
  final AsyncState? fetchPaymentState;
  final AsyncState? paymentMethodState;
  final PostPaymentIntentResponseModel? paymentIntentResponseModel;
  final List<String>? paymentMethods;
  final List<PaymentModel>? payments;

  PaymentState({
    this.createPaymentState,
    this.fetchPaymentState,
    this.paymentMethodState,
    this.paymentIntentResponseModel,
    this.paymentMethods,
    this.payments,
  });

  PaymentState copyWith({
    AsyncState? createPaymentState,
    AsyncState? fetchPaymentState,
    AsyncState? paymentMethodState,
    PostPaymentIntentResponseModel? paymentIntentResponseModel,
    List<String>? paymentMethods,
    List<PaymentModel>? payments,
  }) {
    return PaymentState(
      createPaymentState: createPaymentState ?? this.createPaymentState,
      fetchPaymentState: fetchPaymentState ?? this.fetchPaymentState,
      paymentMethodState: paymentMethodState ?? this.paymentMethodState,
      paymentIntentResponseModel:
          paymentIntentResponseModel ?? this.paymentIntentResponseModel,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      payments: payments ?? this.payments,
    );
  }
}
