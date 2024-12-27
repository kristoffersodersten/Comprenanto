import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../services/haptic_service.dart';
import '../utils/logger.dart';

class TextHandlingService extends ChangeNotifier {
  String _text = '';
  bool _isProcessing = false;
  String? _errorMessage;

  String get text => _text;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  // References cleanup pattern from TranscriptionPage
  Future<void> cleanupText(String text) async {
    try {
      _isProcessing = true;
      notifyListeners();

      _text = text
        .replaceAll(RegExp(r'\b(eh|öh|typ|liksom|alltså)\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

      await copyToClipboard(_text);
      HapticService.success();

    } catch (e) {
      _errorMessage = 'Kunde inte rensa texten';
      HapticService.error();
      AppLogger.error('Text cleanup failed', e);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      HapticService.light();
    } catch (e) {
      _errorMessage = 'Kunde inte kopiera text';
      HapticService.error();
      AppLogger.error('Copy to clipboard failed', e);
      rethrow;
    }
  }

  void clear() {
    _text = '';
    _errorMessage = null;
    _isProcessing = false;
    HapticService.light();
    notifyListeners();
  }
} 