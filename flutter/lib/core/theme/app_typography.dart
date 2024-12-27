import 'package:flutter/material.dart';

class AppTypography {
  static const String primaryFontFamily = 'Roboto';
  static const String fallbackFontFamily = 'NotoSans';

  static TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 57,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  );

  static TextStyle getFallbackStyle(TextStyle style) {
    return style.copyWith(
      fontFamily: fallbackFontFamily,
      package: null,
    );
  }
} 