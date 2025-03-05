import 'package:feedback_work/models/feedback_model.dart';

enum PaymentType {
  totalFeedbackRequestTransaction,
  totalFeedbackAcceptedTransaction,
  totalFeedbackProvidedFreeTransaction,
  totalFeedbackProvidedAtCostTransaction,
}

class PaymentModel {
  final PaymentType? paymentType;
  final String? transactionId;
  final FeedbackModel? feedback;
  final String? requestedByUserId;
  final String? requestedByUserName;
  final String? requestedByUserAvaterUrl;
  final String? providerId;
  final String? providerName;
  final String? providerAvaterUrl;
  final double? feedbackCost;
  final double? bonus;
  final double? totalAmount;
  final String? payAt;
  PaymentModel({
    this.paymentType,
    this.transactionId,
    this.feedback,
    this.requestedByUserId,
    this.requestedByUserName,
    this.requestedByUserAvaterUrl,
    this.providerId,
    this.providerName,
    this.providerAvaterUrl,
    this.feedbackCost,
    this.bonus,
    this.totalAmount,
    this.payAt,
  });

  PaymentModel copyWith({
    PaymentType? paymentType,
    String? transactionId,
    FeedbackModel? feedback,
    String? requestedByUserId,
    String? requestedByUserName,
    String? requestedByUserAvaterUrl,
    String? providerId,
    String? providerName,
    String? providerAvaterUrl,
    double? feedbackCost,
    double? bonus,
    double? totalAmount,
    String? payAt,
  }) {
    return PaymentModel(
      paymentType: paymentType ?? this.paymentType,
      transactionId: transactionId ?? this.transactionId,
      feedback: feedback ?? this.feedback,
      requestedByUserId: requestedByUserId ?? this.requestedByUserId,
      requestedByUserName: requestedByUserName ?? this.requestedByUserName,
      requestedByUserAvaterUrl:
          requestedByUserAvaterUrl ?? this.requestedByUserAvaterUrl,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerAvaterUrl: providerAvaterUrl ?? this.providerAvaterUrl,
      feedbackCost: feedbackCost ?? this.feedbackCost,
      bonus: bonus ?? this.bonus,
      totalAmount: totalAmount ?? this.totalAmount,
      payAt: payAt ?? this.payAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'feedback': feedback?.toMap(),
      'requestedByUserId': requestedByUserId,
      'requestedByUserName': requestedByUserName,
      'requestedByUserAvaterUrl': requestedByUserAvaterUrl,
      'providerId': providerId,
      'providerName': providerName,
      'providerAvaterUrl': providerAvaterUrl,
      'feedbackCost': feedbackCost,
      'bonus': bonus,
      'totalAmount': totalAmount,
      'payAt': DateTime.now().toString(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      feedback: map['feedback'] != null
          ? FeedbackModel.fromMap(map['feedback'] as Map<String, dynamic>)
          : null,
      requestedByUserId: map['requestedByUserId'] != null
          ? map['requestedByUserId'] as String
          : null,
      requestedByUserName: map['requestedByUserName'] != null
          ? map['requestedByUserName'] as String
          : null,
      requestedByUserAvaterUrl: map['requestedByUserAvaterUrl'] != null
          ? map['requestedByUserAvaterUrl'] as String
          : null,
      providerId:
          map['providerId'] != null ? map['providerId'] as String : null,
      providerName:
          map['providerName'] != null ? map['providerName'] as String : null,
      providerAvaterUrl: map['providerAvaterUrl'] != null
          ? map['providerAvaterUrl'] as String
          : null,
      feedbackCost:
          map['feedbackCost'] != null ? map['feedbackCost'] as double : null,
      bonus: map['bonus'] != null ? map['bonus'] as double : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as double : null,
      payAt: map['payAt'] != null ? map['payAt'] as String : null,
    );
  }
}
