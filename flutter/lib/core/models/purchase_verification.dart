class PurchaseVerification {
  final bool isValid;
  final String purchaseToken;
  final DateTime? expiryDate;
  final String? orderId;
  final String status;
  final Map<String, dynamic>? additionalData;

  const PurchaseVerification({
    required this.isValid,
    required this.purchaseToken,
    this.expiryDate,
    this.orderId,
    required this.status,
    this.additionalData,
  });

  factory PurchaseVerification.fromJson(Map<String, dynamic> json) {
    return PurchaseVerification(
      isValid: json['isValid'] as bool,
      purchaseToken: json['purchaseToken'] as String,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      orderId: json['orderId'] as String?,
      status: json['status'] as String,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'purchaseToken': purchaseToken,
      'expiryDate': expiryDate?.toIso8601String(),
      'orderId': orderId,
      'status': status,
      'additionalData': additionalData,
    };
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isActive => isValid && !isExpired;
} 