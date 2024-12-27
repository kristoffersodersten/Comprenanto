import 'package:flutter/material.dart';

class AppStyles {
  static const double defaultRadius = 12.0;
  static const double largeRadius = 25.0;
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(defaultRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultRadius),
      borderSide: BorderSide(color: Colors.grey[600]!),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );

  static BoxDecoration dialogDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
} 