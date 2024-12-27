class ApiConfig {
  static const String baseUrl = 'https://api.yourservice.com';
  static const String apiVersion = '1.0';
  static const String clientId = 'your_client_id';

  // 256-bit (32 bytes) krypteringsnyckel
  static const String encryptionKey = 'your_32_byte_encryption_key_here_12345';

  // API endpoints
  static const String transcription = '/transcribe';
  static const String translation = '/translate';
  static const String languageDetection = '/detect-language';

  static String versioned(String endpoint) => '/v1$endpoint';
}
