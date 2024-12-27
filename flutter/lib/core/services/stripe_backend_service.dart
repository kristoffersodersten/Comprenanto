import '../models/payment_intent.dart';
import '../utils/logger.dart';
import 'api_service.dart'; // Use ApiService instead of Dio

class StripeBackendService {
  final ApiService _apiService; // Use ApiService instead of Dio

  StripeBackendService() : _apiService = ApiService(); // Initialize ApiService

  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/create-payment-intent',
        data: {
          'amount': (amount * 100).toInt(), // Convert to smallest currency unit
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      return PaymentIntent.fromJson(response);
    } catch (e) {
      AppLogger.error('Failed to create payment intent', e);
      rethrow;
    }
  }

  Future<bool> verifySubscription(String paymentIntentId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/verify-subscription',
        data: {
          'paymentIntentId': paymentIntentId,
        },
      );

      return response['success'] == true;
    } catch (e) {
      AppLogger.error('Failed to verify subscription', e);
      return false;
    }
  }
}
