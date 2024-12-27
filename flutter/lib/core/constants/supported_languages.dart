class Language {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

class SupportedLanguages {
  static const List<Language> all = [
    Language(
      code: 'sv',
      name: 'Swedish',
      nativeName: 'Svenska',
    ),
    Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    Language(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
    ),
    Language(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
    ),
    Language(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
    ),
    // Add more languages as needed
  ];

  static Language? fromCode(String code) {
    try {
      return all.firstWhere((lang) => lang.code == code);
    } catch (_) {
      return null;
    }
  }

  static String getDisplayName(String code, {bool useNative = false}) {
    final language = fromCode(code);
    if (language == null) return code;
    return useNative ? language.nativeName : language.name;
  }
} 