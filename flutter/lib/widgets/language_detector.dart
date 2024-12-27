import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/services/haptic_service.dart';
import '../widgets/loading_indicators.dart';

class LanguageDetector extends StatefulWidget {
  final String text;
  final String? initialLanguage;
  final ValueChanged<String>? onLanguageChanged;
  final bool showOverride;
  final Map<String, String> supportedLanguages;

  const LanguageDetector({
    super.key,
    required this.text,
    this.initialLanguage,
    this.onLanguageChanged,
    this.showOverride = true,
    this.supportedLanguages = const {
      'sv': 'Svenska',
      'en': 'English',
      'ar': 'العربية',
      'zh': '中文',
      'ja': '日本語',
    },
  });

  @override
  State<LanguageDetector> createState() => _LanguageDetectorState();
}

class _LanguageDetectorState extends State<LanguageDetector> {
  String? _detectedLanguage;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _detectLanguage(widget.text);
  }

  @override
  void didUpdateWidget(LanguageDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _detectLanguage(widget.text);
    }
  }

  Future<void> _detectLanguage(String text) async {
    if (text.isEmpty) return;

    setState(() => _isDetecting = true);

    try {
      // Mock language detection based on character sets
      await Future.delayed(const Duration(milliseconds: 300));
      String detected;

      if (text.contains(RegExp(r'[أ-ي]'))) {
        detected = 'ar';
      } else if (text.contains(RegExp(r'[一-龯]'))) {
        detected = 'zh';
      } else if (text.contains(RegExp(r'[ぁ-んァ-ン]'))) {
        detected = 'ja';
      } else if (text.contains(RegExp(r'[а-яА-Я]'))) {
        detected = 'ru';
      } else {
        detected = 'sv';
      }

      setState(() {
        _detectedLanguage = detected;
        _isDetecting = false;
      });

      widget.onLanguageChanged?.call(detected);
      HapticService.light();

    } catch (e) {
      setState(() => _isDetecting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kunde inte detektera språk'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDetecting) {
      return LoadingIndicators.buildInlineLoader(
        context: context,
        message: 'Detekterar språk...',
        size: 16,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.globe,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        if (widget.showOverride) ...[
          DropdownButton<String>(
            value: _detectedLanguage ?? widget.initialLanguage ?? 'sv',
            items: widget.supportedLanguages.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() => _detectedLanguage = newValue);
                widget.onLanguageChanged?.call(newValue);
                HapticService.light();
              }
            },
            underline: Container(),
          ),
        ] else ...[
          Text(
            widget.supportedLanguages[_detectedLanguage ?? 'sv'] ?? 'Svenska',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
} 