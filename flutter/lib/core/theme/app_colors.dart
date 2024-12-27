import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primaryLight = Color(0xFF4A4A4A);
  static const Color primaryDark = Color(0xFFF8F5F0);
  
  // Accent colors
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentBlue = Color(0xFF4A90E2);
  
  // Background colors
  static const MaterialColor neutralGrey = MaterialColor(
    0xFF2C2C2C,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(0xFF9E9E9E),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF212121),
    },
  );

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textLight = Color(0xFFF8F5F0);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF3C3C3C);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A4A4A),
      Color(0xFF2C2C2C),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFBF9B30),
    ],
  );

  // Theme-specific getters
  static Color getSurfaceColor(bool isDark) => 
      isDark ? surfaceDark : surfaceLight;
  
  static Color getTextColor(bool isDark) => 
      isDark ? textLight : textPrimary;
  
  static Color getAccentColor(bool isDark) => 
      isDark ? accentGold : accentBlue;
} 