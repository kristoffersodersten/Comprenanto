import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/haptic_service.dart';

class InteractiveFeedback {
  // Durations
  static const Duration pressedDuration = Duration(milliseconds: 50);
  static const Duration releaseDuration = Duration(milliseconds: 200);

  // Scale factors
  static const double pressedScale = 0.98;
  static const double defaultScale = 1.0;

  // Feedback types
  static void success({bool withHaptic = true}) {
    if (withHaptic) HapticService.success();
  }

  static void error({bool withHaptic = true}) {
    if (withHaptic) HapticService.error();
  }

  static void buttonPress({bool withHaptic = true}) {
    if (withHaptic) HapticService.buttonPress();
  }

  // Interactive states
  static ButtonStyle getInteractiveButtonStyle({
    required BuildContext context,
    Color? backgroundColor,
    double elevation = 2.0,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDestructive
        ? AppColors.error
        : (backgroundColor ?? Theme.of(context).primaryColor);

    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return defaultColor.withAlpha(204);
        }
        if (states.contains(MaterialState.disabled)) {
          return defaultColor.withAlpha(128);
        }
        return defaultColor;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.textTertiary;
        }
        return isDark ? AppColors.textLight : AppColors.textPrimary;
      }),
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return elevation / 2;
        }
        if (states.contains(MaterialState.disabled)) {
          return elevation / 3;
        }
        return elevation;
      }),
      padding: MaterialStateProperty.all(
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return defaultColor.withAlpha(26);
        }
        return null;
      }),
    );
  }

  static Widget wrapInteractive({
    required Widget child,
    required VoidCallback? onTap,
    bool withScale = true,
    bool withHaptic = true,
    bool withOverlay = true,
    Color? overlayColor,
    double borderRadius = 8.0,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return GestureDetector(
          onTapDown: (_) {
            if (onTap != null) {
              setState(() => isPressed = true);
              if (withHaptic) HapticService.light();
            }
          },
          onTapUp: (_) {
            if (onTap != null) {
              setState(() => isPressed = false);
              onTap();
            }
          },
          onTapCancel: () {
            setState(() => isPressed = false);
          },
          child: AnimatedContainer(
            duration: isPressed ? pressedDuration : releaseDuration,
            transform: Matrix4.identity()
              ..scale(isPressed ? pressedScale : defaultScale),
            child: withOverlay
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(borderRadius),
                      overlayColor: MaterialStateProperty.all(
                        overlayColor ?? AppColors.primaryLight.withAlpha(26),
                      ),
                      child: child,
                    ),
                  )
                : child,
          ),
        );
      },
    );
  }
}
