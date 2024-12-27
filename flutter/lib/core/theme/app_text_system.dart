import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTextSystem {
  // Font families
  static const String primaryFont = AppTypography.primaryFontFamily;
  static const String cjkFont = AppTypography.fallbackFontFamily;

  // Line heights
  static const double tightHeight = 1.2;
  static const double normalHeight = 1.5;
  static const double looseHeight = 1.8;

  // Letter spacing
  static const double tightSpacing = -0.5;
  static const double normalSpacing = 0.0;
  static const double looseSpacing = 0.5;

  static TextStyle getStyle({
    required BuildContext context,
    required TextStyleType type,
    String? languageCode,
    Color? color,
    bool emphasized = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseStyle = _getBaseStyle(type);
    final fontFamily = _getFontFamily(languageCode);
    
    return baseStyle.copyWith(
      color: color ?? (isDark ? AppColors.textLight : AppColors.textPrimary),
      fontFamily: fontFamily,
      height: _getLineHeight(languageCode),
      letterSpacing: _getLetterSpacing(type, languageCode),
    );
  }

  static TextStyle _getBaseStyle(TextStyleType type) {
    switch (type) {
      case TextStyleType.displayLarge:
        return AppTypography.textTheme.displayLarge!.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: tightSpacing,
        );
      case TextStyleType.displayMedium:
        return AppTypography.textTheme.displayMedium!.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: tightSpacing,
        );
      case TextStyleType.titleLarge:
        return AppTypography.textTheme.titleLarge!.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: normalSpacing,
        );
      case TextStyleType.titleMedium:
        return AppTypography.textTheme.titleMedium!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: normalSpacing,
        );
      case TextStyleType.bodyLarge:
        return AppTypography.textTheme.bodyLarge!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: looseSpacing,
          height: normalHeight,
        );
      case TextStyleType.bodyMedium:
        return AppTypography.textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: normalSpacing,
          height: normalHeight,
        );
      case TextStyleType.labelLarge:
        return AppTypography.textTheme.labelLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: normalSpacing,
        );
    }
  }

  static String _getFontFamily(String? languageCode) {
    if (languageCode?.startsWith('ja') == true || 
        languageCode?.startsWith('zh') == true || 
        languageCode?.startsWith('ko') == true) {
      return cjkFont;
    }
    return primaryFont;
  }

  static double _getLineHeight(String? languageCode) {
    if (languageCode?.startsWith('ja') == true || 
        languageCode?.startsWith('zh') == true || 
        languageCode?.startsWith('ko') == true) {
      return looseHeight;
    }
    return normalHeight;
  }

  static double _getLetterSpacing(TextStyleType type, String? languageCode) {
    // CJK languages typically don't need letter spacing
    if (languageCode?.startsWith('ja') == true || 
        languageCode?.startsWith('zh') == true || 
        languageCode?.startsWith('ko') == true) {
      return 0.0;
    }
    
    switch (type) {
      case TextStyleType.displayLarge:
      case TextStyleType.displayMedium:
        return tightSpacing;
      case TextStyleType.titleLarge:
      case TextStyleType.titleMedium:
      case TextStyleType.labelLarge:
        return normalSpacing;
      case TextStyleType.bodyLarge:
      case TextStyleType.bodyMedium:
        return looseSpacing;
    }
  }
}

enum TextStyleType {
  displayLarge,
  displayMedium,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  labelLarge,
} 