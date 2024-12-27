import 'package:flutter/material.dart';
import 'app_text_styles.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final double minFontSize;
  final double maxFontSize;
  final bool allowWrapping;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.minFontSize = 12.0,
    this.maxFontSize = 32.0,
    this.allowWrapping = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = (screenWidth + screenHeight) / 1500; // Base scale reference

    final TextStyle defaultStyle = baseStyle ?? AppTextStyles.bodyMedium;
    final double responsiveFontSize = (defaultStyle.fontSize ?? 14.0) * scaleFactor;
    
    final adjustedFontSize = responsiveFontSize.clamp(minFontSize, maxFontSize);

    if (allowWrapping) {
      return Text(
        text,
        style: defaultStyle.copyWith(fontSize: adjustedFontSize),
        textAlign: textAlign,
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: defaultStyle.copyWith(fontSize: adjustedFontSize),
        textAlign: textAlign,
      ),
    );
  }

  // Factory constructors for common text variants
  factory ResponsiveText.display(String text, {Key? key}) => ResponsiveText(
    text,
    key: key,
    baseStyle: AppTextStyles.displayLarge,
    minFontSize: 24.0,
    maxFontSize: 48.0,
  );

  factory ResponsiveText.title(String text, {Key? key}) => ResponsiveText(
    text,
    key: key,
    baseStyle: AppTextStyles.titleLarge,
    minFontSize: 18.0,
    maxFontSize: 32.0,
  );

  factory ResponsiveText.body(String text, {Key? key}) => ResponsiveText(
    text,
    key: key,
    baseStyle: AppTextStyles.bodyLarge,
    minFontSize: 14.0,
    maxFontSize: 24.0,
    allowWrapping: true,
  );
} 