enum PaymentType {
  totalFeedbackRequestTransaction,
  totalFeedbackAcceptedTransaction,
  totalFeedbackProvidedFreeTransaction,
  totalFeedbackProvidedAtCostTransaction,
}

class PaymentModel {
  final PaymentType? paymentType;
  final String? transactionId;
  final String? feedbackId;
  final double? feedbackCost;
  final double? bonus;
  PaymentModel({
    this.paymentType,
    this.transactionId,
    this.feedbackId,
    this.feedbackCost,
    this.bonus,
  });

  PaymentModel copyWith({
    PaymentType? paymentType,
    String? transactionId,
    String? feedbackId,
    double? feedbackCost,
    double? bonus,
  }) {
    return PaymentModel(
      paymentType: paymentType ?? this.paymentType,
      transactionId: transactionId ?? this.transactionId,
      feedbackId: feedbackId ?? this.feedbackId,
      feedbackCost: feedbackCost ?? this.feedbackCost,
      bonus: bonus ?? this.bonus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'feedbackId': feedbackId,
      'feedbackCost': feedbackCost,
      'bonus': bonus,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      feedbackId:
          map['feedbackId'] != null ? map['feedbackId'] as String : null,
      feedbackCost:
          map['feedbackCost'] != null ? map['feedbackCost'] as double : null,
      bonus: map['bonus'] != null ? map['bonus'] as double : null,
    );
  }
}
