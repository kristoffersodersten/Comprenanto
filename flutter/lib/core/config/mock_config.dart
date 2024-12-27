class MockConfig {
  // Mock API Configuration
  static const String mockApiBaseUrl = 'https://mockapi.example.com/v1';
  static const Duration mockApiTimeout = Duration(seconds: 5);

  // Mock App Information
  static const String mockAppName = 'Mock Voice Translator';
  static const String mockAppVersion = '1.0.0-mock';

  // Mock Stripe Configuration
  static const String mockStripePublishKey = 'pk_test_mock_...';
  static const String mockStripeSecretKey = 'sk_test_mock_...';
  static const String mockStripeBackendUrl =
      'https://mockapi.example.com/stripe';

  // Mock Subscription Configuration
  static const int mockTrialPeriodDays = 7;
  static const double mockMonthlySubscriptionPrice = 49.0;
  static const String mockSubscriptionCurrency = 'USD';

  // Mock Error Tracking
  static const String mockSentryDsn = 'https://mock...@sentry.io/...';

  // Mock Feature Flags
  static const bool mockEnableAnalytics = false;
  static const bool mockEnableErrorTracking = false;
  static const bool mockEnableOfflineMode = true;

  // Mock Cache Configuration
  static const Duration mockCacheDuration = Duration(hours: 12);
  static const int mockMaxCacheSize = 50;
}