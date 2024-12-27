import 'package:flutter/material.dart';
import '../core/models/subscription_plan.dart';
import '../core/theme/spacing.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onSubscribe;

  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: Column(
          children: [
            Text(
              plan.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Spacing.medium),
            Text(
              plan.formattedPrice,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: Spacing.medium),
            ...plan.features.map((feature) => _FeatureItem(text: feature)),
            SizedBox(height: Spacing.large),
            ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Subscribe Now'),
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
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: Spacing.small),
          Text(text),
        ],
      ),
    );
  }
} 