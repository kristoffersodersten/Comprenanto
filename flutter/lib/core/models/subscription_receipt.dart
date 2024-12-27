class SubscriptionReceipt {
  final String receipt;
  final String transactionId;
  final DateTime purchaseDate;
  final String? orderId;
  final Map<String, dynamic>? metadata;

  const SubscriptionReceipt({
    required this.receipt,
    required this.transactionId,
    required this.purchaseDate,
    this.orderId,
    this.metadata,
  });

  factory SubscriptionReceipt.fromJson(Map<String, dynamic> json) {
    return SubscriptionReceipt(
      receipt: json['receipt'] as String,
      transactionId: json['transactionId'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      orderId: json['orderId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receipt': receipt,
      'transactionId': transactionId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'orderId': orderId,
      'metadata': metadata,
    };
  }

  SubscriptionReceipt copyWith({
    String? receipt,
    String? transactionId,
    DateTime? purchaseDate,
    String? orderId,
    Map<String, dynamic>? metadata,
  }) {
    return SubscriptionReceipt(
      receipt: receipt ?? this.receipt,
      transactionId: transactionId ?? this.transactionId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      orderId: orderId ?? this.orderId,
      metadata: metadata ?? this.metadata,
    );
  }
} 