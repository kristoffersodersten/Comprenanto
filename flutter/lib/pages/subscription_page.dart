import 'package:flutter/material.dart';
import '../core/services/subscription_service.dart';
import '../widgets/subscription_card.dart';
import '../core/theme/spacing.dart';
import '../core/utils/error_handler.dart';

class SubscriptionPage extends StatelessWidget {
  final SubscriptionService subscriptionService;

  const SubscriptionPage({
    super.key,
    required this.subscriptionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Subscription'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upgrade to Premium',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Spacing.medium),
            Text(
              'Get unlimited access to all features',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Spacing.large),
            SubscriptionCard(
              plan: subscriptionService.monthlyPlan,
              onSubscribe: () => _handleSubscribe(context),
            ),
            SizedBox(height: Spacing.medium),
            Text(
              '3 days free trial, then ${subscriptionService.monthlyPlan.formattedPrice}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubscribe(BuildContext context) async {
    try {
      final success = await subscriptionService.subscribe();
      if (success && context.mounted) {
        Navigator.of(context).pop(true);
      } else if (context.mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          ErrorHandler.handle(
            Exception('Subscription Failed: Unable to process subscription. Please try again.'),
            StackTrace.current,
          ),
        );
      }
    } catch (e, stackTrace) {
      if (context.mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          ErrorHandler.handle(e, stackTrace),
        );
      }
    }
  }
} 