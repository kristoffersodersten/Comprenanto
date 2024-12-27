import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure_storage;
import 'dart:convert';
import '../utils/logger.dart';

class SecureStorageService {
  static const _subscriptionKey = 'subscription_data';
  static const _purchaseTokenKey = 'purchase_token';
  
  final secure_storage.FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const secure_storage.FlutterSecureStorage();

  Future<void> saveSubscriptionData(Map<String, dynamic> data) async {
    try {
      await _storage.write(
        key: _subscriptionKey,
        value: jsonEncode(data),
      );
    } catch (e) {
      AppLogger.error('Failed to save subscription data', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSubscriptionData() async {
    try {
      final data = await _storage.read(key: _subscriptionKey);
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to read subscription data', e);
      return null;
    }
  }

  Future<void> savePurchaseToken(String token) async {
    try {
      await _storage.write(
        key: _purchaseTokenKey,
        value: token,
      );
    } catch (e) {
      AppLogger.error('Failed to save purchase token', e);
      rethrow;
    }
  }

  Future<String?> getPurchaseToken() async {
    try {
      return await _storage.read(key: _purchaseTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read purchase token', e);
      return null;
    }
  }

  Future<void> clearSubscriptionData() async {
    try {
      await _storage.delete(key: _subscriptionKey);
      await _storage.delete(key: _purchaseTokenKey);
    } catch (e) {
      AppLogger.error('Failed to clear subscription data', e);
      rethrow;
    }
  }
} 