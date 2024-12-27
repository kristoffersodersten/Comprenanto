import 'package:flutter/material.dart';
import '../utils/logger.dart';
// Removed the import of 'app_localizations.dart' as it doesn't exist

class OfflineLocalizations {
  static const fallbackLocale = Locale('sv');

  static final Map<String, Map<String, String>> _fallbackTranslations = {
    'en': {
      'appTitle': 'Comprenanto',
      'transcriptionTitle': 'Transcription',
      'translationTitle': 'Translation',
      'sourceText': 'Source text',
      'targetText': 'Translated text',
      'transcribedText': 'Transcribed text',
      'cleanupText': 'Clean text',
      'copyText': 'Copy text',
      'textCopied': 'Text copied',
      'textCleaned': 'Text cleaned',
      'transcriptionComplete': 'Transcription complete',
      'translating': 'Translating...',
      'transcribing': 'Transcribing...',
      'errorGeneric': 'An error occurred',
      'placeholderTranslation': 'Translation will appear here...',
      'placeholderTranscription': 'Speak to transcribe...',
      'languageDetected': 'Detected language: ',
    },
    'sv': {
      'appTitle': 'Comprenanto',
      'transcriptionTitle': 'Transkribering',
      'translationTitle': 'Översättning',
      'sourceText': 'Källtext',
      'targetText': 'Översatt text',
      'transcribedText': 'Transkriberad text',
      'cleanupText': 'Rensa text',
      'copyText': 'Kopiera text',
      'textCopied': 'Text kopierad',
      'textCleaned': 'Text rensad',
      'transcriptionComplete': 'Transkribering klar',
      'translating': 'Översätter...',
      'transcribing': 'Transkriberar...',
      'errorGeneric': 'Ett fel uppstod',
      'placeholderTranslation': 'Översättningen visas här...',
      'placeholderTranscription': 'Tala för att transkribera...',
      'languageDetected': 'Upptäckt språk: ',
    },
  };

  static String getString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context);
    final translations = _fallbackTranslations[locale.languageCode] ??
        _fallbackTranslations[fallbackLocale.languageCode]!;

    final result = translations[key] ?? key;

    AppLogger.debug(
      'Falling back to offline translation for "$key": "$result"',
    );

    return result;
  }

  static bool isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return ['ar', 'fa', 'he'].contains(locale.languageCode);
  }

  static TextDirection getTextDirection(BuildContext context) {
    return isRTL(context) ? TextDirection.rtl : TextDirection.ltr;
  }
}