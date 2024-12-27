import 'package:flutter/material.dart';
import '../core/models/subscription_status.dart';
import '../core/theme/spacing.dart';

class SubscriptionStatusBar extends StatelessWidget {
  final SubscriptionStatus status;
  final VoidCallback? onRenew;

  const SubscriptionStatusBar({
    super.key,
    required this.status,
    this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    if (!status.isActive && !status.isTrialing) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(Spacing.small),
      color: _getBackgroundColor(context),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            size: 16,
            color: _getTextColor(context),
          ),
          SizedBox(width: Spacing.small),
          Expanded(
            child: Text(
              _getMessage(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getTextColor(context),
              ),
            ),
          ),
          if (status.needsRenewal && onRenew != null)
            TextButton(
              onPressed: onRenew,
              style: TextButton.styleFrom(
                foregroundColor: _getTextColor(context),
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.medium,
                ),
              ),
              child: const Text('Renew'),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (status.isTrialing) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    if (status.needsRenewal) {
      return Theme.of(context).colorScheme.errorContainer;
    }
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  Color _getTextColor(BuildContext context) {
    if (status.isTrialing) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
    if (status.needsRenewal) {
      return Theme.of(context).colorScheme.onErrorContainer;
    }
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  IconData _getIcon() {
    if (status.isTrialing) return Icons.access_time;
    if (status.needsRenewal) return Icons.warning;
    return Icons.check_circle;
  }

  String _getMessage() {
    if (status.isTrialing) {
      final daysLeft = status.trialEndDate!
          .difference(DateTime.now())
          .inDays;
      return 'Trial period - $daysLeft days remaining';
    }
    if (status.needsRenewal) {
      return 'Your subscription will expire soon';
    }
    return 'Premium subscription active';
  }
} 