class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String interval;
  final List<String> features;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
  });

  String get formattedPrice => '$price $currency/$interval';
} 