import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle get displayLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Theme-specific variants
  static TextStyle withTheme(TextStyle base, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return base.copyWith(
      color: isDark ? AppColors.textLight : AppColors.textDark,
    );
  }

  static TextStyle withColor(TextStyle base, Color color) {
    return base.copyWith(color: color);
  }

  static TextStyle withEmphasis(TextStyle base, {double opacity = 0.6}) {
    return base.copyWith(color: base.color?.withOpacity(opacity));
  }
}

class AppColors {
  static const Color textLight = Color(0xFFFFFFFF); // Example color for light text
  static const Color textDark = Color(0xFF000000); // Example color for dark text
}