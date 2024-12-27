import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/services/haptic_service.dart';

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;
  final bool isDestructive;
  final Duration animationDuration;

  const AnimatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
    this.isDestructive = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticService.light();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isLoading ? _pulseAnimation.value : _scaleAnimation.value,
            child: _buildButton(context),
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(context),
            blurRadius: _isPressed ? 4 : 8,
            offset: _isPressed ? const Offset(0, 1) : const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              color: _getTextColor(context),
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          if (widget.isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context)),
              ),
            )
          else
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getTextColor(context),
                    fontWeight: FontWeight.w600,
                  ),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.onPressed == null) return Colors.grey[300]!;
    if (widget.isDestructive) return AppColors.error;
    return widget.isPrimary ? AppColors.primaryLight : AppColors.surfaceLight;
  }

  Color _getTextColor(BuildContext context) {
    if (widget.onPressed == null) return Colors.grey[500]!;
    if (widget.isDestructive) return Colors.white;
    return widget.isPrimary ? Colors.white : AppColors.primaryLight;
  }

  Color _getShadowColor(BuildContext context) {
    return (widget.isDestructive ? AppColors.error : AppColors.primaryLight)
        .withOpacity(_isPressed ? 0.2 : 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}