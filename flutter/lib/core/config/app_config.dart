class AppConfig {
  // App Information
  static const String appName = 'Voice Translator';
  static const String appVersion = '1.0.0';
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  static const Duration apiTimeout = Duration(seconds: 30);

  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Stripe Configuration
  static const String stripePublishKey = String.fromEnvironment(
    'STRIPE_PUBLISH_KEY',
    defaultValue: 'pk_test_...',
  );

  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'sk_test_...',
  );

  static const String stripeBackendUrl = String.fromEnvironment(
    'STRIPE_BACKEND_URL',
    defaultValue: 'https://api.example.com/stripe',
  );

  // Subscription Configuration
  static const int trialPeriodDays = 3;
  static const double monthlySubscriptionPrice = 99.0;
  static const String subscriptionCurrency = 'SEK';

  // Error Tracking
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://...@sentry.io/...',
  );

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableErrorTracking = true;
  static const bool enableOfflineMode = false;

  // Cache Configuration
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCacheSize = 100;
}
