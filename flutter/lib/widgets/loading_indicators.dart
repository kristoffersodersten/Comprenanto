import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/theme/app_colors.dart';
import '../core/theme/app_elevation.dart';
import '../core/interaction/feedback_system.dart';

class LoadingIndicators {
  // Overlay loading indicator with blur
  static Widget buildOverlayLoader({
    required BuildContext context,
    required String message,
    bool isDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return Stack(
      children: [
        // Blur overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),

        // Loading card
        Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: Card(
                elevation: AppElevation.level3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppElevation.radiusLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProgressIndicator(context),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Dismiss button if enabled
        if (isDismissible && onDismiss != null)
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                InteractiveFeedback.buttonPress();
                onDismiss();
              },
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  // Inline loading indicator
  static Widget buildInlineLoader({
    required BuildContext context,
    String? message,
    double size = 24,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: _buildProgressIndicator(
            context,
            strokeWidth: size / 8,
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  // Custom progress indicator
  static Widget _buildProgressIndicator(
    BuildContext context, {
    double strokeWidth = 3,
  }) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // Success completion indicator
  static Widget buildSuccessIndicator({
    required BuildContext context,
    required String message,
    VoidCallback? onDismiss,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppElevation.radiusMedium),
            boxShadow: AppElevation.getShadow(AppElevation.level2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onDismiss,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
