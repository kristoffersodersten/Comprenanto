import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final languages = ['sv', 'en', 'ar', 'ja', 'zh'];

    return DropdownButton<String>(
      value: currentLanguage,
      items: languages
          .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang.toUpperCase()),
              ))
          .toList(),
      onChanged: onLanguageChanged,
    );
  }
}
