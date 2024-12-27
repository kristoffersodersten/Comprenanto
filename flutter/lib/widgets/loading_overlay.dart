import 'package:flutter/material.dart';
// import '../core/constants/theme_constants.dart';
import '../core/utils/logger.dart';

class LoadingOverlay extends StatefulWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? progressColor;
  final double opacity;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const LoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.progressColor,
    this.opacity = 0.7,
    this.dismissible = false,
    this.onDismiss,
  }) : assert(
          !dismissible || onDismiss != null,
          'onDismiss must be provided when dismissible is true',
        );

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Replace with appropriate duration
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    AppLogger.debug('LoadingOverlay initialized');
  }

  Future<void> _dismiss() async {
    if (!widget.dismissible || !_isVisible) return;

    try {
      setState(() => _isVisible = false);
      await _controller.reverse();
      widget.onDismiss?.call();
    } catch (e, stackTrace) {
      AppLogger.error('Error dismissing overlay', e, stackTrace);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    AppLogger.debug('LoadingOverlay disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _animation,
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.dismissible ? _dismiss : null,
            child: Container(
              color: (widget.backgroundColor ?? 
                     theme.colorScheme.surface)
                     .withOpacity(widget.opacity),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.progressColor ?? theme.colorScheme.primary,
                  ),
                ),
                if (widget.message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.message!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          Semantics(
            label: widget.message ?? 'Loading',
            value: widget.dismissible ? 'Tap to dismiss' : null,
            button: widget.dismissible,
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
} 