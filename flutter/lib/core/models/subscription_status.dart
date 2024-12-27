class SubscriptionStatus {
  final bool isActive;
  final DateTime? trialEndDate;
  final DateTime? subscriptionEndDate;
  final String? planId;
  final String status;

  const SubscriptionStatus({
    required this.isActive,
    this.trialEndDate,
    this.subscriptionEndDate,
    this.planId,
    required this.status,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      isActive: json['isActive'] as bool,
      trialEndDate: json['trialEndDate'] != null 
          ? DateTime.parse(json['trialEndDate'] as String)
          : null,
      subscriptionEndDate: json['subscriptionEndDate'] != null 
          ? DateTime.parse(json['subscriptionEndDate'] as String)
          : null,
      planId: json['planId'] as String?,
      status: json['status'] as String,
    );
  }

  bool get isTrialing => 
      trialEndDate != null && trialEndDate!.isAfter(DateTime.now());

  bool get needsRenewal =>
      subscriptionEndDate != null && 
      subscriptionEndDate!.difference(DateTime.now()).inDays <= 7;
} 