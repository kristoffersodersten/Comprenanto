import 'package:flutter/material.dart';
import '../core/models/subscription_status.dart';
import '../core/theme/spacing.dart';
import '../core/utils/subscription_utils.dart';

class SubscriptionInfoCard extends StatelessWidget {
  final SubscriptionStatus status;
  final VoidCallback? onManage;

  const SubscriptionInfoCard({
    super.key,
    required this.status,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(context),
                ),
                SizedBox(width: Spacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: Spacing.tiny),
                      Text(
                        SubscriptionUtils.getStatusMessage(status),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (onManage != null)
                  TextButton(
                    onPressed: onManage,
                    child: const Text('Manage'),
                  ),
              ],
            ),
            if (_showWarning) ...[
              SizedBox(height: Spacing.medium),
              Container(
                padding: EdgeInsets.all(Spacing.small),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: Spacing.small),
                    Expanded(
                      child: Text(
                        _getWarningMessage(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    if (status.isTrialing) return Icons.access_time;
    if (status.isActive) return Icons.check_circle;
    return Icons.cancel;
  }

  Color _getStatusColor(BuildContext context) {
    if (!status.isActive) {
      return Theme.of(context).colorScheme.error;
    }
    if (status.needsRenewal) {
      return Theme.of(context).colorScheme.secondary.withOpacity(0.8);
    }
    return Theme.of(context).colorScheme.primary;
  }

  String _getStatusTitle() {
    if (status.isTrialing) return 'Trial Active';
    if (status.isActive) return 'Premium Active';
    return 'Subscription Inactive';
  }

  bool get _showWarning {
    return SubscriptionUtils.shouldShowTrialEndingWarning(status) ||
        SubscriptionUtils.shouldShowRenewalWarning(status);
  }

  String _getWarningMessage() {
    if (status.isTrialing) {
      return 'Your trial is ending soon. Subscribe to continue using premium features.';
    }
    return 'Your subscription will expire soon. Please renew to maintain access.';
  }
} 