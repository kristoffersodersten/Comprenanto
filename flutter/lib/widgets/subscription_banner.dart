import 'package:flutter/material.dart';
import '../core/models/subscription_status.dart';
import '../core/theme/spacing.dart';
import '../core/utils/subscription_utils.dart';

class SubscriptionBanner extends StatelessWidget {
  final SubscriptionStatus status;
  final VoidCallback onAction;

  const SubscriptionBanner({
    super.key,
    required this.status,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getTextColor(context),
            size: 24,
          ),
          SizedBox(width: Spacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getTextColor(context),
                  ),
                ),
                if (_getMessage() != null) ...[
                  SizedBox(height: Spacing.tiny),
                  Text(
                    _getMessage()!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getTextColor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: _getTextColor(context),
            ),
            child: Text(_getActionText()),
          ),
        ],
      ),
    );
  }

  bool get _shouldShow {
    return SubscriptionUtils.shouldShowTrialEndingWarning(status) ||
        SubscriptionUtils.shouldShowRenewalWarning(status);
  }

  Color _getBackgroundColor(BuildContext context) {
    if (status.isTrialing) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    return Theme.of(context).colorScheme.errorContainer;
  }

  Color _getTextColor(BuildContext context) {
    if (status.isTrialing) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return Theme.of(context).colorScheme.onErrorContainer;
  }

  IconData _getIcon() {
    if (status.isTrialing) return Icons.access_time;
    return Icons.warning;
  }

  String _getTitle() {
    if (status.isTrialing) return 'Trial Ending Soon';
    return 'Subscription Expiring';
  }

  String? _getMessage() {
    return SubscriptionUtils.getStatusMessage(status);
  }

  String _getActionText() {
    if (status.isTrialing) return 'Subscribe';
    return 'Renew';
  }
} 