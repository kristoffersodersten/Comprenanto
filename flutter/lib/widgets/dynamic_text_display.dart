import 'package:flutter/material.dart';
import '../core/utils/script_detector.dart';
import '../core/theme/app_typography.dart';

class DynamicTextDisplay extends StatelessWidget {
  final String text;
  final String? languageCode;
  final TextStyle? style;
  final bool selectable;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  final bool enableTTB;

  const DynamicTextDisplay({
    super.key,
    required this.text,
    this.languageCode,
    this.style,
    this.selectable = true,
    this.onTap,
    this.textAlign,
    this.enableTTB = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = (style ?? Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(fontFamily: _getFontFamily());
    
    final textDirection = languageCode != null 
        ? _getTextDirectionFromLanguage(languageCode!)
        : ScriptDetector.getTextDirection(text);
    
    final isVertical = enableTTB && 
        (languageCode?.startsWith('ja') == true || 
         languageCode?.startsWith('zh') == true);

    Widget textWidget = selectable
        ? SelectableText(
            text,
            style: effectiveStyle,
            textDirection: textDirection,
            textAlign: textAlign ?? _getTextAlign(isVertical, textDirection),
            onTap: onTap,
          )
        : Text(
            text,
            style: effectiveStyle,
            textDirection: textDirection,
            textAlign: textAlign ?? _getTextAlign(isVertical, textDirection),
          );

    if (isVertical) {
      return RotatedBox(
        quarterTurns: 1,
        child: textWidget,
      );
    }

    return textWidget;
  }

  String _getFontFamily() {
    if (languageCode?.startsWith('ja') == true || 
        languageCode?.startsWith('zh') == true) {
      return AppTypography.fallbackFontFamily;
    }
    return AppTypography.primaryFontFamily;
  }

  TextDirection _getTextDirectionFromLanguage(String languageCode) {
    return ['ar', 'he', 'fa'].contains(languageCode) 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }

  TextAlign _getTextAlign(bool isVertical, TextDirection direction) {
    if (isVertical) return TextAlign.center;
    return direction == TextDirection.rtl 
        ? TextAlign.right 
        : TextAlign.left;
  }
} 