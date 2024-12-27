import '../config/app_config.dart';
import '../models/subscription_status.dart';
import '../utils/logger.dart';
import 'api_service.dart'; // Use ApiService instead of Dio

class SubscriptionBackend {
  final ApiService _apiService; // Use ApiService instead of Dio

  SubscriptionBackend() : _apiService = ApiService(); // Initialize ApiService

  Future<bool> activateSubscription({
    required String userId,
    required String paymentIntentId,
    required Map<String, dynamic> receiptData,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/activate',
        data: {
          'userId': userId,
          'paymentIntentId': paymentIntentId,
          'receipt': receiptData,
          'platform': _getPlatform(),
          'appVersion': AppConfig.appVersion,
        },
      );

      return response['success'] == true;
    } catch (e) {
      AppLogger.error('Failed to activate subscription', e);
      return false;
    }
  }

  Future<SubscriptionStatus> getStatus(String userId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/status/$userId',
      );

      return SubscriptionStatus.fromJson(response);
    } catch (e) {
      AppLogger.error('Failed to get subscription status', e);
      rethrow;
    }
  }

  Future<bool> cancelSubscription({
    required String userId,
    required String reason,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/cancel',
        data: {
          'userId': userId,
          'reason': reason,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response['success'] == true;
    } catch (e) {
      AppLogger.error('Failed to cancel subscription', e);
      return false;
    }
  }

  String _getPlatform() {
    if (AppConfig.isIOS) return 'ios';
    if (AppConfig.isAndroid) return 'android';
    return 'unknown';
  }
}
