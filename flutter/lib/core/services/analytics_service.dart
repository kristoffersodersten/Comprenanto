import '../models/subscription_status.dart';
import '../utils/logger.dart';

class AnalyticsService {
  Future<void> logSubscriptionEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      // Assuming a placeholder for logging since FirebaseAnalytics is not available
      AppLogger.debug('Logging event: $eventName with parameters: $parameters');
    } catch (e) {
      AppLogger.error('Failed to log analytics event', e);
    }
  }

  Future<void> logSubscriptionStarted({
    required String planId,
    required double amount,
    required String currency,
    required bool isTrialConversion,
  }) async {
    await logSubscriptionEvent(
      eventName: 'subscription_started',
      parameters: {
        'plan_id': planId,
        'amount': amount,
        'currency': currency,
        'is_trial_conversion': isTrialConversion,
      },
    );
  }

  Future<void> logSubscriptionCancelled({
    required String planId,
    required String reason,
  }) async {
    await logSubscriptionEvent(
      eventName: 'subscription_cancelled',
      parameters: {
        'plan_id': planId,
        'reason': reason,
      },
    );
  }

  Future<void> logTrialStarted() async {
    await logSubscriptionEvent(
      eventName: 'trial_started',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSubscriptionStatusChange({
    required SubscriptionStatus oldStatus,
    required SubscriptionStatus newStatus,
  }) async {
    await logSubscriptionEvent(
      eventName: 'subscription_status_changed',
      parameters: {
        'old_status': oldStatus.status,
        'new_status': newStatus.status,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}