import '../config/app_config.dart';
import '../models/subscription_plan.dart';
import '../utils/logger.dart';
import 'storage_service.dart';
import 'stripe_backend_service.dart'; // Import the StripeBackendService

class SubscriptionService {
  final StorageService _storage;
  final StripeBackendService _stripeBackendService; // Add StripeBackendService
  static const _subscriptionKey = 'subscription_status';
  static const _trialEndKey = 'trial_end_date';

  SubscriptionService(this._storage)
      : _stripeBackendService = StripeBackendService(); // Initialize StripeBackendService

  Future<void> initialize() async {
    if (AppConfig.stripePublishKey.isEmpty) {
      AppLogger.error('Stripe publishable key is not set.');
      return;
    }
    // Stripe initialization logic can be moved to StripeBackendService if needed
  }

  Future<bool> isSubscriptionActive() async {
    final status = await _storage.getString(_subscriptionKey);
    if (status == 'active') return true;

    // Check trial period
    final trialEnd = await getTrialEndDate();
    if (trialEnd != null && trialEnd.isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }

  Future<DateTime?> getTrialEndDate() async {
    final trialEndStr = await _storage.getString(_trialEndKey);
    if (trialEndStr == null) return null;
    return DateTime.tryParse(trialEndStr);
  }

  Future<void> startTrial() async {
    final trialEnd = DateTime.now().add(const Duration(days: 3));
    await _storage.setString(_trialEndKey, trialEnd.toIso8601String());
  }

  Future<bool> subscribe() async {
    try {
      // Create payment intent using StripeBackendService
      final paymentIntent = await _stripeBackendService.createPaymentIntent(
        amount: monthlyPlan.price.toDouble(),
        currency: monthlyPlan.currency,
      );

      // Initialize payment sheet
      // Assuming you have a method to initialize and present the payment sheet
      await _initializeAndPresentPaymentSheet(paymentIntent.clientSecret);

      // Update subscription status
      await _storage.setString(_subscriptionKey, 'active');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Subscription failed', e, stackTrace);
      return false;
    }
  }

  Future<void> _initializeAndPresentPaymentSheet(String clientSecret) async {
    // Implement the logic to initialize and present the payment sheet
    // This is a placeholder for the actual implementation
    throw UnimplementedError();
  }

  SubscriptionPlan get monthlyPlan => SubscriptionPlan(
        id: 'monthly_99sek',
        name: 'Monthly Premium',
        price: 99,
        currency: 'SEK',
        interval: 'month',
        features: [
          'Unlimited translations',
          'Offline mode',
          'Priority support',
          'No ads',
        ],
      );
}