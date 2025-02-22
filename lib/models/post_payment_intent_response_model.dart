import 'dart:convert';

class PostPaymentIntentResponseModel {
  final String id;
  final String object;
  final int amount;
  final int amountCapturable;
  final int amountReceived;
  final String captureMethod;
  final String clientSecret;
  final String confirmationMethod;
  final int created;
  final String currency;
  final bool livemode;
  final Map<String, dynamic> metadata;
  final String? status;
  final List<String> paymentMethodTypes;
  final String? application;
  final int? canceledAt;
  final String? cancellationReason;
  final String? customer;
  final String? description;
  final String? invoice;
  final String? lastPaymentError;
  final String? latestCharge;
  final String? onBehalfOf;
  final String? paymentMethod;
  final Map<String, dynamic>? paymentMethodOptions;
  final String? processing;
  final String? receiptEmail;
  final String? review;
  final String? setupFutureUsage;
  final String? shipping;
  final String? source;
  final String? statementDescriptor;
  final String? statementDescriptorSuffix;
  final Map<String, dynamic>? transferData;
  final String? transferGroup;

  PostPaymentIntentResponseModel({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCapturable,
    required this.amountReceived,
    required this.captureMethod,
    required this.clientSecret,
    required this.confirmationMethod,
    required this.created,
    required this.currency,
    required this.livemode,
    required this.metadata,
    required this.status,
    required this.paymentMethodTypes,
    this.application,
    this.canceledAt,
    this.cancellationReason,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.latestCharge,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.processing,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.transferData,
    this.transferGroup,
  });

  factory PostPaymentIntentResponseModel.fromJson(Map<String, dynamic> json) {
    return PostPaymentIntentResponseModel(
      id: json['id'],
      object: json['object'],
      amount: json['amount'],
      amountCapturable: json['amount_capturable'],
      amountReceived: json['amount_received'],
      captureMethod: json['capture_method'],
      clientSecret: json['client_secret'],
      confirmationMethod: json['confirmation_method'],
      created: json['created'],
      currency: json['currency'],
      livemode: json['livemode'],
      metadata: json['metadata'] ?? {},
      status: json['status'],
      paymentMethodTypes: List<String>.from(json['payment_method_types'] ?? []),
      application: json['application'],
      canceledAt: json['canceled_at'],
      cancellationReason: json['cancellation_reason'],
      customer: json['customer'],
      description: json['description'],
      invoice: json['invoice'],
      lastPaymentError: json['last_payment_error'],
      latestCharge: json['latest_charge'],
      onBehalfOf: json['on_behalf_of'],
      paymentMethod: json['payment_method'],
      paymentMethodOptions: json['payment_method_options'],
      processing: json['processing'],
      receiptEmail: json['receipt_email'],
      review: json['review'],
      setupFutureUsage: json['setup_future_usage'],
      shipping: json['shipping'],
      source: json['source'],
      statementDescriptor: json['statement_descriptor'],
      statementDescriptorSuffix: json['statement_descriptor_suffix'],
      transferData: json['transfer_data'],
      transferGroup: json['transfer_group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'amount': amount,
      'amount_capturable': amountCapturable,
      'amount_received': amountReceived,
      'capture_method': captureMethod,
      'client_secret': clientSecret,
      'confirmation_method': confirmationMethod,
      'created': created,
      'currency': currency,
      'livemode': livemode,
      'metadata': metadata,
      'status': status,
      'payment_method_types': paymentMethodTypes,
      'application': application,
      'canceled_at': canceledAt,
      'cancellation_reason': cancellationReason,
      'customer': customer,
      'description': description,
      'invoice': invoice,
      'last_payment_error': lastPaymentError,
      'latest_charge': latestCharge,
      'on_behalf_of': onBehalfOf,
      'payment_method': paymentMethod,
      'payment_method_options': paymentMethodOptions,
      'processing': processing,
      'receipt_email': receiptEmail,
      'review': review,
      'setup_future_usage': setupFutureUsage,
      'shipping': shipping,
      'source': source,
      'statement_descriptor': statementDescriptor,
      'statement_descriptor_suffix': statementDescriptorSuffix,
      'transfer_data': transferData,
      'transfer_group': transferGroup,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
