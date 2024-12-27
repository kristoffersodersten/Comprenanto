import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SecureApiService {
  late final Key _encryptionKey;
  late final String _hmacKey;
  late final String _baseUrl;

  SecureApiService() {
    _encryptionKey = Key.fromBase64(dotenv.env['ENCRYPTION_KEY'] ?? '');
    _hmacKey = dotenv.env['HMAC_KEY'] ?? '';
    _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3001';
  }

  Future<Map<String, dynamic>> secureRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      // Generate IV
      final iv = IV.fromSecureRandom(16);

      // Encrypt data
      final encrypter = Encrypter(AES(_encryptionKey, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(jsonEncode(data), iv: iv);

      // Calculate HMAC
      final hmac = Hmac(sha256, utf8.encode(_hmacKey));
      final signature = hmac.convert(encrypted.bytes).toString();

      // Make HTTP request
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'X-Initialization-Vector': base64.encode(iv.bytes),
          'X-Hmac-Signature': signature,
        },
        body: jsonEncode({
          'data': encrypted.base64,
        }),
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}: ${response.body}');
      }

      // Decrypt response
      final encryptedResponse = response.body;
      final decrypted = encrypter.decrypt64(
        encryptedResponse,
        iv: iv,
      );

      return jsonDecode(decrypted);
    } catch (e) {
      print('Secure request failed: $e');
      rethrow;
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}
