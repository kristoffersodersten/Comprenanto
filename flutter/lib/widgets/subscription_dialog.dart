import 'package:flutter/material.dart';
import '../core/models/subscription_plan.dart';
import '../core/theme/spacing.dart';
import '../core/utils/subscription_utils.dart';

class SubscriptionDialog extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onSubscribe;
  final VoidCallback onTrial;
  final bool isLoading;
  final bool hasTrialAvailable;

  const SubscriptionDialog({
    super.key,
    required this.plan,
    required this.onSubscribe,
    required this.onTrial,
    this.isLoading = false,
    this.hasTrialAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upgrade to Premium',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: Spacing.medium),
            ...plan.features.map((feature) => _FeatureItem(text: feature)),
            SizedBox(height: Spacing.large),
            if (hasTrialAvailable) ...[
              ElevatedButton(
                onPressed: isLoading ? null : onTrial,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'Start ${SubscriptionUtils.getTrialPeriodText(3)}',
                ),
              ),
              SizedBox(height: Spacing.medium),
            ],
            ElevatedButton(
              onPressed: isLoading ? null : onSubscribe,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text('Subscribe for ${plan.formattedPrice}'),
            ),
            SizedBox(height: Spacing.medium),
            Text(
              'Cancel anytime. Subscription auto-renews monthly.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.small),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: Spacing.small),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
} 