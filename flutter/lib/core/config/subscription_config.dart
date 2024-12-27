class SubscriptionConfig {
  // Trial settings
  static const int trialPeriodDays = 3;
  static const bool enableTrialReminders = true;
  
  // Subscription settings
  static const double monthlyPrice = 99.0;
  static const String currency = 'SEK';
  static const bool enableAutoRenewal = true;
  
  // Feature flags
  static const List<String> premiumFeatures = [
    'Unlimited translations',
    'Offline mode',
    'Priority support',
    'No ads',
    'High-quality voice output',
  ];
  
  // Notification settings
  static const int renewalReminderDays = 7;
  static const int trialEndReminderDays = 1;
  
  // URLs
  static const String termsUrl = 'https://example.com/terms';
  static const String privacyUrl = 'https://example.com/privacy';
  static const String subscriptionTermsUrl = 'https://example.com/subscription-terms';
} 