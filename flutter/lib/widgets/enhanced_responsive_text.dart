import 'package:flutter/material.dart';
import '../core/utils/script_detector.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_text_styles.dart';

class EnhancedResponsiveText extends StatelessWidget {
  final String text;
  final String? languageCode;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final double minFontSize;
  final double maxFontSize;
  final bool allowWrapping;
  final bool selectable;
  final VoidCallback? onTap;
  final bool enableVertical;

  const EnhancedResponsiveText(
    this.text, {
    super.key,
    this.languageCode,
    this.baseStyle,
    this.textAlign,
    this.minFontSize = 12.0,
    this.maxFontSize = 32.0,
    this.allowWrapping = true,
    this.selectable = false,
    this.onTap,
    this.enableVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = (screenWidth + screenHeight) / 1500;

    final defaultStyle = baseStyle ?? AppTextStyles.bodyMedium;
    final responsiveFontSize = (defaultStyle.fontSize ?? 14.0) * scaleFactor;
    final adjustedFontSize = responsiveFontSize.clamp(minFontSize, maxFontSize);

    final effectiveStyle = defaultStyle.copyWith(
      fontSize: adjustedFontSize,
      fontFamily: _getFontFamily(),
    );

    final textDirection = languageCode != null
        ? _getTextDirectionFromLanguage(languageCode!)
        : ScriptDetector.getTextDirection(text);

    final isVertical = enableVertical &&
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

    if (!allowWrapping) {
      textWidget = FittedBox(
        fit: BoxFit.scaleDown,
        child: textWidget,
      );
    }

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

  TextAlign _getTextAlign(bool isVertical, TextDirection direction) {
    if (isVertical) {
      return TextAlign.justify;
    }
    return direction == TextDirection.rtl ? TextAlign.right : TextAlign.left;
  }

  TextDirection _getTextDirectionFromLanguage(String languageCode) {
    return ['ar', 'he', 'fa'].contains(languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
} 