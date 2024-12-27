import 'package:flutter/material.dart';

class PremiumComponents {
  static ButtonStyle elevatedButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return 2;
        if (states.contains(WidgetState.disabled)) return 0;
        return 4;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.primary.withOpacity(0.4);
        }
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withOpacity(0.8);
        }
        return colorScheme.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onPrimary.withOpacity(0.4);
        }
        return colorScheme.onPrimary;
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      overlayColor: WidgetStateProperty.all(
        colorScheme.primary.withOpacity(0.1),
      ),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  static InputDecoration textFieldDecoration(
    BuildContext context, {
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface.withOpacity(0.5),
      ),
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.outline,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),
    );
  }

  static BoxDecoration cardDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: colorScheme.outline.withOpacity(0.2),
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
} 