import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TranslationNotifier extends ChangeNotifier {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final ApiService _apiService;
  bool _isTranslating = false;

  TranslationNotifier(this._apiService);

  bool get isTranslating => _isTranslating;

  Future<void> translateText() async {
    _isTranslating = true;
    notifyListeners();

    try {
      // Assuming the correct method name is 'getTranslation' instead of 'translateText'
      final response = await _apiService.getTranslation(
        sourceController.text,
        'sv', // Example: Source language
        'en', // Example: Target language
      );
      targetController.text = response.translatedText;
    } catch (e) {
      debugPrint('Translation failed: $e');
    } finally {
      _isTranslating = false;
      notifyListeners();
    }
  }
}

class TranslationResponse {
  final String translatedText;

  TranslationResponse({required this.translatedText});

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      translatedText: json['translation'] as String,
    );
  }
}
