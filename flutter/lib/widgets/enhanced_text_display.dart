import 'package:flutter/material.dart';
import '../core/utils/script_detector.dart';
import '../core/theme/app_typography.dart';

class EnhancedTextDisplay extends StatelessWidget {
  final String text;
  final String? languageCode;
  final TextStyle? style;
  final bool selectable;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  final bool enableVertical;
  final EdgeInsets padding;
  final double? maxHeight;
  final double? minHeight;
  final BoxDecoration? decoration;

  const EnhancedTextDisplay({
    super.key,
    required this.text,
    this.languageCode,
    this.style,
    this.selectable = true,
    this.onTap,
    this.textAlign,
    this.enableVertical = true,
    this.padding = const EdgeInsets.all(16),
    this.maxHeight,
    this.minHeight,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
      fontFamily: _getFontFamily(),
      height: _getLineHeight(),
      letterSpacing: _getLetterSpacing(),
    );

    final textDirection = languageCode != null
        ? _getTextDirectionFromLanguage(languageCode!)
        : ScriptDetector.getTextDirection(text);

    final isVertical = enableVertical && _shouldUseVerticalLayout();

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

    textWidget = Container(
      padding: padding,
      decoration: decoration,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? 0,
      ),
      child: textWidget,
    );

    if (isVertical) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RotatedBox(
                quarterTurns: textDirection == TextDirection.rtl ? -1 : 1,
                child: textWidget,
              ),
            ),
          );
        },
      );
    }

    return textWidget;
  }

  bool _shouldUseVerticalLayout() {
    return languageCode?.startsWith('ja') == true ||
        languageCode?.startsWith('zh') == true ||
        ScriptDetector.isCJK(text);
  }

  String _getFontFamily() {
    if (_shouldUseVerticalLayout()) {
      return AppTypography.fallbackFontFamily;
    }
    return AppTypography.primaryFontFamily;
  }

  double _getLineHeight() {
    if (_shouldUseVerticalLayout()) {
      return 1.8; // Increased line height for vertical text
    }
    return 1.5;
  }

  double _getLetterSpacing() {
    if (_shouldUseVerticalLayout()) {
      return 0.1; // Slight spacing for vertical text
    }
    return 0.0;
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
