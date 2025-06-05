import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/payment_model.dart';
import 'package:feedback_work/models/post_payment_intent_response_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:feedback_work/core/constants/api_endpoints.dart';
import 'package:feedback_work/core/utils/network/rest_client/rest_client.dart';
import 'package:feedback_work/core/utils/utils.dart';

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);

class PaymentNotifier extends Notifier<PaymentState> {
  final supabase = Supabase.instance.client;

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

  // Future<void> initializePaymentSheet({
  //   required String amount,
  //   String currency = 'USD',
  // }) async {
  //   try {
  //     createPaymentIntent(
  //       amount: amount,
  //       currency: currency,
  //     );

  //     if (state.paymentIntentResponseModel != null) {
  //       await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //           allowsDelayedPaymentMethods: true,
  //           paymentIntentClientSecret:
  //               state.paymentIntentResponseModel!.clientSecret,
  //           style: ThemeMode.system,
  //           merchantDisplayName: 'Feedback Work',
  //         ),
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     Log.error(e.toString());
  //     Log.error(stackTrace.toString());
  //   }
  // }

  Future<void> initializePaymentSheet({
    required String amount,
    String currency = 'USD',
  }) async {
    try {
      // Await the creation of the payment intent
      await createPaymentIntent(
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
      } else {
        Log.error("Payment intent response is null");
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
      );
      ref.read(feedbackProvider.notifier).appliedFeedback(
            feedback: feedbackModel,
            appliedFeedback: appliedFeedback,
            callback: callBack,
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
    try {
      state = state.copyWith(fetchPaymentState: AsyncState.loading);
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser?.id == null) {
        throw Exception('No user logged in');
      }
      final userId = currentUser!.id!;

      final requestedByMePayments = await supabase
          .from('payments')
          .select()
          .eq('requested_by_user_id', userId);

      final providedByMePayments =
          await supabase.from('payments').select().eq('provider_id', userId);

      state = state.copyWith(
          requestedByMePayments: (requestedByMePayments as List)
              .map((c) => PaymentModel.fromMap(c))
              .toList(),
          providedByMePayments: (providedByMePayments as List)
              .map((c) => PaymentModel.fromMap(c))
              .toList(),
          fetchPaymentState: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(fetchPaymentState: AsyncState.failure);
    }
  }

  Future<void> fetchPaymentById({required String paymentId}) async {
    try {
      state = state.copyWith(fetchPaymentState: AsyncState.loading);
      final payment =
          await supabase.from('payments').select().eq('id', paymentId).single();

      if (payment != null) {
        state = state.copyWith(
            singlePayment: PaymentModel.fromMap(payment),
            fetchPaymentState: AsyncState.success);
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(fetchPaymentState: AsyncState.failure);
    }
  }

  Future<int> getDocumentCount({required String collectionName}) async {
    try {
      state = state.copyWith(documentCountState: AsyncState.loading);
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser?.id == null) {
        throw Exception('No user logged in');
      }
      final userId = currentUser!.id!;

      final response =
          await supabase.from(collectionName).select().eq('user_id', userId);

      state = state.copyWith(documentCountState: AsyncState.success);
      return (response as List).length;
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
    try {
      state = state.copyWith(createPaymentState: AsyncState.loading);

      // Begin transaction
      await supabase.rpc('create_payment', params: {
        'payment_data': paymentModel.toMap(),
        'feedback_id': feedbackModel.id,
        'owner_id': feedbackModel.ownerId,
        'provider_id': feedbackModel.providerId,
        'feedback_cost': paymentModel.feedbackCost ?? 0,
        'bonus': paymentModel.bonus ?? 0,
        'is_free': feedbackModel.requestFeedback?.cost == 0,
      });

      callback?.call();
      state = state.copyWith(createPaymentState: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      state = state.copyWith(createPaymentState: AsyncState.failure);
    }
  }

  Future<String?> stripePublishableKey({void Function()? callback}) async {
    try {
      String key = '';
      final docRef = await supabase
          .from('api_keys')
          .select()
          .eq('key', 'stripePublishableKey')
          .single();
      if (docRef != null) {
        key = docRef['value'] ?? '';
      }

      callback?.call();
      return key;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
      return null;
    }
  }

  Future<String?> stripeSecretKey({void Function()? callback}) async {
    try {
      String key = '';
      final docRef = await supabase
          .from('api_keys')
          .select()
          .eq('key', 'stripeSecretKey')
          .single();
      if (docRef != null) {
        key = docRef['value'] ?? '';
      }

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
