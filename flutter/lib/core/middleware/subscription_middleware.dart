import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../utils/error_handler.dart';
import '../../pages/subscription_page.dart';

class SubscriptionMiddleware {
  final SubscriptionService _subscriptionService;

  const SubscriptionMiddleware(this._subscriptionService);

  Future<bool> checkAccess(BuildContext context) async {
    try {
      final isSubscribed = await _subscriptionService.isSubscriptionActive();
      
      if (!isSubscribed && context.mounted) {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => SubscriptionPage(
              subscriptionService: _subscriptionService,
            ),
          ),
        );
        
        return result ?? false;
      }
      
      return isSubscribed;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          ErrorHandler.handle(e, stackTrace),
        );
      }
      return false;
    }
  }
} 