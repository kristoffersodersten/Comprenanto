import 'package:flutter/material.dart';
import '../core/config/app_config.dart';

class EnhancedContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onTap;
  final String? errorMessage;
  final bool enableAnimation;
  final double elevation;
  final BorderRadius? borderRadius;

  const EnhancedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.isLoading = false,
    this.hasError = false,
    this.onTap,
    this.errorMessage,
    this.enableAnimation = true,
    this.elevation = 1.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);

    Widget content = Material(
      color: backgroundColor ?? theme.cardColor,
      elevation: elevation,
      borderRadius: effectiveBorderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: hasError
                ? theme.colorScheme.error
                : theme.dividerColor.withOpacity(0.1),
            width: hasError ? 1.5 : 1.0,
          ),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: Stack(
          children: [
            child,
            if (isLoading)
              Positioned.fill(
                child: _buildLoadingOverlay(theme),
              ),
            if (hasError && errorMessage != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildErrorMessage(theme),
              ),
          ],
        ),
      ),
    );

    if (enableAnimation) {
      content = AnimatedContainer(
        duration: AppConfig.animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: hasError
                  ? theme.colorScheme.error.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: elevation * 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      );
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: content,
      );
    }

    return content;
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor.withOpacity(0.8),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(11),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Text(
        errorMessage!,
        style: TextStyle(
          color: theme.colorScheme.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}