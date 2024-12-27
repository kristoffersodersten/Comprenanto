import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_schemes.dart';
import 'text_themes.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorSchemes.lightColorScheme,
    textTheme: TextThemes.textTheme,
    fontFamily: GoogleFonts.inter().fontFamily,
    
    // Component themes
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorSchemes.lightColorScheme.surface,
      elevation: 0,
      iconTheme: IconThemeData(
        color: ColorSchemes.lightColorScheme.onSurface,
      ),
      titleTextStyle: TextThemes.textTheme.titleLarge?.copyWith(
        color: ColorSchemes.lightColorScheme.onSurface,
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorSchemes.darkColorScheme,
    textTheme: TextThemes.textTheme,
    fontFamily: GoogleFonts.inter().fontFamily,
    
    // Component themes
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorSchemes.darkColorScheme.surface,
      elevation: 0,
      iconTheme: IconThemeData(
        color: ColorSchemes.darkColorScheme.onSurface,
      ),
      titleTextStyle: TextThemes.textTheme.titleLarge?.copyWith(
        color: ColorSchemes.darkColorScheme.onSurface,
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  );
}
