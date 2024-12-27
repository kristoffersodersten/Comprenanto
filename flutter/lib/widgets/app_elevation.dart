import 'package:flutter/material.dart';

class AppElevation {
  static const double level1 = 1.0;
  static const double level2 = 4.0;
  static const double level3 = 8.0;
  static const double level4 = 16.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;

  static List<BoxShadow> getShadow(double elevation) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0, elevation / 2),
        blurRadius: elevation,
      ),
    ];
  }
}
