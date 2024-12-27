import '../models/subscription_status.dart';

class SubscriptionUtils {
  static String getStatusMessage(SubscriptionStatus status) {
    if (status.isTrialing) {
      final daysLeft = _getDaysRemaining(status.trialEndDate!);
      if (daysLeft == 0) {
        return 'Trial ends today';
      }
      return 'Trial ends in $daysLeft days';
    }

    if (!status.isActive) {
      return 'Subscription inactive';
    }

    if (status.needsRenewal) {
      final daysLeft = _getDaysRemaining(status.subscriptionEndDate!);
      return 'Renew in $daysLeft days';
    }

    return 'Subscription active';
  }

  static int _getDaysRemaining(DateTime endDate) {
    return endDate.difference(DateTime.now()).inDays;
  }

  static String formatPrice(double amount, String currency) {
    return '$amount $currency';
  }

  static String getTrialPeriodText(int days) {
    return '$days-day free trial';
  }

  static bool shouldShowTrialEndingWarning(SubscriptionStatus status) {
    if (!status.isTrialing) return false;
    final daysLeft = _getDaysRemaining(status.trialEndDate!);
    return daysLeft <= 1;
  }

  static bool shouldShowRenewalWarning(SubscriptionStatus status) {
    if (!status.isActive || status.isTrialing) return false;
    final daysLeft = _getDaysRemaining(status.subscriptionEndDate!);
    return daysLeft <= 7;
  }
} 