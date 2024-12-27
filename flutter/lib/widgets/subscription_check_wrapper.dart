import 'package:flutter/material.dart';
import '../core/services/subscription_service.dart';
import '../pages/subscription_page.dart';

class SubscriptionCheckWrapper extends StatelessWidget {
  final Widget child;
  final bool requiresSubscription;
  final SubscriptionService subscriptionService;

  const SubscriptionCheckWrapper({
    super.key,
    required this.child,
    required this.requiresSubscription,
    required this.subscriptionService,
  });

  @override
  Widget build(BuildContext context) {
    if (!requiresSubscription) return child;

    return FutureBuilder<bool>(
      future: subscriptionService.isSubscriptionActive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final isSubscribed = snapshot.data ?? false;
        if (isSubscribed) return child;

        return SubscriptionPage(
          subscriptionService: subscriptionService,
        );
      },
    );
  }
} 