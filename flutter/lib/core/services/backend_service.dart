import '../models/subscription_status.dart';
import '../utils/logger.dart';
import 'api_service.dart'; // Import the correct service

class BackendService {
  final ApiService _apiService; // Use ApiService instead of Dio

  BackendService() : _apiService = ApiService(); // Initialize ApiService

  Future<SubscriptionStatus> checkSubscriptionStatus(String userId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/subscription/status/$userId',
      );

      return SubscriptionStatus.fromJson(response);
    } catch (e) {
      AppLogger.error('Failed to check subscription status', e);
      rethrow;
    }
  }

  Future<bool> activateSubscription({
    required String userId,
    required String paymentIntentId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/subscription/activate',
        data: {
          'userId': userId,
          'paymentIntentId': paymentIntentId,
        },
      );

      return response['success'] == true;
    } catch (e) {
      AppLogger.error('Failed to activate subscription', e);
      return false;
    }
  }

  Future<bool> cancelSubscription(String userId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/subscription/cancel',
        data: {
          'userId': userId,
        },
      );

      return response['success'] == true;
    } catch (e) {
      AppLogger.error('Failed to cancel subscription', e);
      return false;
    }
  }
}
