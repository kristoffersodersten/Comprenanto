import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import 'middleware_service.dart';

enum TranslationState { idle, translating, error }

class TranslationService extends ChangeNotifier {
  final MiddlewareService _middlewareService;
  
  TranslationState _state = TranslationState.idle;
  String _sourceText = '';
  String _translatedText = '';
  String? _errorMessage;
  String _sourceLanguage = 'sv';
  String _targetLanguage = 'en';
  
  TranslationService(this._middlewareService);

  // Public getters
  TranslationState get state => _state;
  String get sourceText => _sourceText;
  String get translatedText => _translatedText;
  String? get errorMessage => _errorMessage;
  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;

  Future<void> translate({
    required String text,
    String? from,
    String? to,
  }) async {
    if (text.isEmpty) {
      _handleError('Source text cannot be empty');
      return;
    }

    try {
      _state = TranslationState.translating;
      _sourceText = text;
      _errorMessage = null;
      notifyListeners();

      final result = await _middlewareService.translateText(
        text: text,
        fromLanguage: from ?? _sourceLanguage,
        toLanguage: to ?? _targetLanguage,
      );

      _translatedText = result.translatedText;
      _state = TranslationState.idle;
      notifyListeners();
      
      AppLogger.info('Translation completed successfully');
    } catch (e) {
      _handleError('Translation failed: $e');
    }
  }

  void setLanguages({String? source, String? target}) {
    bool shouldNotify = false;

    if (source != null && source != _sourceLanguage) {
      _sourceLanguage = source;
      shouldNotify = true;
    }

    if (target != null && target != _targetLanguage) {
      _targetLanguage = target;
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void clearTranslation() {
    _sourceText = '';
    _translatedText = '';
    _errorMessage = null;
    _state = TranslationState.idle;
    notifyListeners();
  }

  void _handleError(String message) {
    _state = TranslationState.error;
    _errorMessage = message;
    AppLogger.error(message);
    notifyListeners();
  }

  @override
  void dispose() {
    // Cleanup if needed
    super.dispose();
  }
} 