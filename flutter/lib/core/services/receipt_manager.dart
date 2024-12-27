import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../storage/secure_storage_service.dart';
import '../models/purchase_verification.dart';
import '../utils/logger.dart';

class ReceiptManager {
  final SecureStorageService _storage;

  ReceiptManager(this._storage);

  Future<void> storeReceipt({
    required String receipt,
    required String transactionId,
    required DateTime purchaseDate,
  }) async {
    try {
      final receiptData = {
        'receipt': receipt,
        'transactionId': transactionId,
        'purchaseDate': purchaseDate.toIso8601String(),
        'hash': _generateReceiptHash(receipt, transactionId),
      };

      await _storage.saveSubscriptionData(receiptData);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to store receipt', e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getStoredReceipt() async {
    try {
      final data = await _storage.getSubscriptionData();
      if (data == null) return null;

      final receipt = data['receipt'] as String;
      final transactionId = data['transactionId'] as String;
      final storedHash = data['hash'] as String;

      // Verify receipt integrity
      final calculatedHash = _generateReceiptHash(receipt, transactionId);
      if (calculatedHash != storedHash) {
        AppLogger.error('Receipt hash mismatch');
        await _storage.clearSubscriptionData();
        return null;
      }

      return data;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to retrieve receipt', e, stackTrace);
      return null;
    }
  }

  String _generateReceiptHash(String receipt, String transactionId) {
    final data = utf8.encode('$receipt:$transactionId');
    return sha256.convert(data).toString();
  }

  Future<void> clearReceipt() async {
    try {
      await _storage.clearSubscriptionData();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear receipt', e, stackTrace);
      rethrow;
    }
  }

  bool isReceiptValid(PurchaseVerification verification) {
    return verification.isValid && !verification.isExpired;
  }
} 