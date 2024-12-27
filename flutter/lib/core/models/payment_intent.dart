class PaymentIntent {
  final String id;
  final String clientSecret;
  final String status;
  final int amount;
  final String currency;

  PaymentIntent({
    required this.id,
    required this.clientSecret,
    required this.status,
    required this.amount,
    required this.currency,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      status: json['status'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_secret': clientSecret,
      'status': status,
      'amount': amount,
      'currency': currency,
    };
  }

  bool get isSuccessful => status == 'succeeded';
} 