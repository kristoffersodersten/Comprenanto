import '../config/app_config.dart';
import '../models/purchase_verification.dart';
import '../utils/logger.dart';
import 'api_service.dart'; // Use ApiService instead of Dio

class PurchaseVerifier {
  final ApiService _apiService; // Use ApiService instead of Dio

  PurchaseVerifier() : _apiService = ApiService(); // Initialize ApiService

  Future<PurchaseVerification> verifyPurchase({
    required String purchaseToken,
    required String productId,
    required String transactionId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/verify-purchase',
        data: {
          'purchaseToken': purchaseToken,
          'productId': productId,
          'transactionId': transactionId,
          'platform': _getPlatform(),
        },
      );

      return PurchaseVerification.fromJson(response);
    } catch (e) {
      AppLogger.error('Purchase verification failed', e);
      rethrow;
    }
  }

  Future<bool> validateReceipt({
    required String receipt,
    String? transactionId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/validate-receipt',
        data: {
          'receipt': receipt,
          'transactionId': transactionId,
          'platform': _getPlatform(),
        },
      );

      return response['isValid'] == true;
    } catch (e) {
      AppLogger.error('Receipt validation failed', e);
      return false;
    }
  }

  String _getPlatform() {
    if (AppConfig.isIOS) return 'ios';
    if (AppConfig.isAndroid) return 'android';
    return 'unknown';
  }
}
