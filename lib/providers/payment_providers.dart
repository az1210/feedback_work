import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/payment_model.dart';
import 'package:feedback_work/models/post_payment_intent_response_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
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
    required FeedbackModel feedbackModel,
    required AppliedModel appliedFeedback,
    void Function()? callBack,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      createPayment(
        paymentModel: paymentModel.copyWith(
          transactionId: state.paymentIntentResponseModel!.id,
        ),
        feedbackModel: feedbackModel,
        callback: callBack,
      );
      ref.read(feedbackProvider.notifier).appliedFeedback(
            feedback: feedbackModel,
            appliedFeedback: appliedFeedback,
          );
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

  Future<void> fetchMyPayments() async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(fetchPaymentState: AsyncState.loading);
      final requestedByMePaymentsSnapshot = await firestore
          .collection(FirebaseConstants.paymentCollection)
          .where('requestedByUserId',
              isEqualTo: ref.watch(currentUserProvider)!.id)
          .get();
      final providedByMePaymentsSnapshot = await firestore
          .collection(FirebaseConstants.paymentCollection)
          .where('providerId', isEqualTo: ref.watch(currentUserProvider)!.id)
          .get();

      final requestedByMePayments = requestedByMePaymentsSnapshot.docs
          .map((c) => PaymentModel.fromMap(c.data()))
          .toList();

      final providedByMePayments = providedByMePaymentsSnapshot.docs
          .map((c) => PaymentModel.fromMap(c.data()))
          .toList();
      state = state.copyWith(
          requestedByMePayments: requestedByMePayments,
          providedByMePayments: providedByMePayments,
          fetchPaymentState: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> fetchPaymentById({required String paymentId}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(fetchPaymentState: AsyncState.loading);
      final paymentsSnapshot = await firestore
          .collection(FirebaseConstants.paymentCollection)
          .doc(paymentId)
          .get();

      final payment =
          PaymentModel.fromMap(paymentsSnapshot.data() as Map<String, dynamic>);
      state = state.copyWith(
          singlePayment: payment, fetchPaymentState: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<int> getDocumentCount({required String collectionName}) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(documentCountState: AsyncState.loading);
      final collection = firestore
          .collection(FirebaseConstants.userCollection)
          .doc(ref.watch(currentUserProvider)!.id!)
          .collection(collectionName);
      final countQuery = await collection.count().get();
      state = state.copyWith(documentCountState: AsyncState.success);
      return countQuery.count ?? 0;
    } catch (e) {
      Log.error(e.toString());
      state = state.copyWith(documentCountState: AsyncState.failure);
      return 0;
    }
  }

  Future<void> createPayment({
    required PaymentModel paymentModel,
    required FeedbackModel feedbackModel,
    void Function()? callback,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      state = state.copyWith(createPaymentState: AsyncState.loading);
      await firestore
          .collection(FirebaseConstants.paymentCollection)
          .doc(paymentModel.transactionId)
          .set(paymentModel.toMap());
      await firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(paymentModel.feedback!.id!)
          .set({'paymentId': paymentModel.transactionId});
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(feedbackModel.ownerId)
          .collection(FirebaseConstants.totalFeedbackAcceptedTransaction)
          .doc(paymentModel.transactionId)
          .set({'paymentId': paymentModel.transactionId});
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(feedbackModel.ownerId)
          .update({
        'totalFeedbackAcceptedAmount': FieldValue.increment(
            paymentModel.feedbackCost ?? 0 + paymentModel.bonus!)
      });
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(feedbackModel.providerId)
          .collection(feedbackModel.requestFeedback!.cost != 0
              ? FirebaseConstants.totalFeedbackProvidedAtCostTransaction
              : FirebaseConstants.totalFeedbackProvidedFreeTransaction)
          .doc(paymentModel.transactionId)
          .set({'paymentId': paymentModel.transactionId});
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(feedbackModel.providerId)
          .update({
        'totalFeedbackProvidedAtCostAmount': FieldValue.increment(
            paymentModel.feedbackCost ?? 0 + paymentModel.bonus!)
      });
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
  final AsyncState? documentCountState;
  final PostPaymentIntentResponseModel? paymentIntentResponseModel;
  final List<String>? paymentMethods;
  final List<PaymentModel>? requestedByMePayments;
  final List<PaymentModel>? providedByMePayments;
  final PaymentModel? singlePayment;

  PaymentState({
    this.createPaymentState,
    this.fetchPaymentState,
    this.paymentMethodState,
    this.documentCountState,
    this.paymentIntentResponseModel,
    this.paymentMethods,
    this.requestedByMePayments,
    this.providedByMePayments,
    this.singlePayment,
  });

  PaymentState copyWith({
    AsyncState? createPaymentState,
    AsyncState? fetchPaymentState,
    AsyncState? paymentMethodState,
    AsyncState? documentCountState,
    PostPaymentIntentResponseModel? paymentIntentResponseModel,
    List<String>? paymentMethods,
    List<PaymentModel>? requestedByMePayments,
    List<PaymentModel>? providedByMePayments,
    PaymentModel? singlePayment,
  }) {
    return PaymentState(
      createPaymentState: createPaymentState ?? this.createPaymentState,
      fetchPaymentState: fetchPaymentState ?? this.fetchPaymentState,
      paymentMethodState: paymentMethodState ?? this.paymentMethodState,
      documentCountState: documentCountState ?? this.documentCountState,
      paymentIntentResponseModel:
          paymentIntentResponseModel ?? this.paymentIntentResponseModel,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      requestedByMePayments:
          requestedByMePayments ?? this.requestedByMePayments,
      providedByMePayments: providedByMePayments ?? this.providedByMePayments,
      singlePayment: singlePayment ?? this.singlePayment,
    );
  }
}
