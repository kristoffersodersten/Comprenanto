import '../utils/logger.dart';
import '../models/transcription_result.dart';
import '../models/translation_result.dart';
import 'api_service.dart'; // Use ApiService instead of Dio

class MiddlewareService {
  final ApiService _apiService; // Use ApiService instead of Dio
  final _cache = <String, dynamic>{};

  MiddlewareService() : _apiService = ApiService(); // Initialize ApiService

  Future<TranscriptionResult> transcribeAudio({
    required List<int> audioData,
    String? language,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/transcribe',
        data: {
          'audio': audioData,
          if (language != null) 'language': language,
        },
      );

      return TranscriptionResult.fromJson(response);
    } catch (e) {
      AppLogger.error('Transcription failed', e);
      rethrow;
    }
  }

  Future<TranslationResult> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      final cacheKey = _generateCacheKey(text, fromLanguage, toLanguage);

      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey] as TranslationResult;
      }

      final response = await _apiService.post<Map<String, dynamic>>(
        '/translate',
        data: {
          'text': text,
          'from': fromLanguage,
          'to': toLanguage,
        },
      );

      final result = TranslationResult.fromJson(response);
      _cache[cacheKey] = result;

      return result;
    } catch (e) {
      AppLogger.error('Translation failed', e);
      rethrow;
    }
  }

  String _generateCacheKey(String text, String from, String to) {
    return '$text:$from:$to';
  }

  void clearCache() {
    _cache.clear();
  }
}
