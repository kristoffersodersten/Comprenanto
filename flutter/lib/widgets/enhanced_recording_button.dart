import 'package:flutter/material.dart';
import '../core/services/feedback_service.dart';

class EnhancedRecordingButton extends StatefulWidget {
  final Stream<double>? audioStream;
  final bool isRecording;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;
  final Color? activeColor;
  final double size;

  const EnhancedRecordingButton({
    super.key,
    this.audioStream,
    this.isRecording = false,
    this.onRecordingStart,
    this.onRecordingStop,
    this.activeColor,
    this.size = 64,
  });

  @override
  State<EnhancedRecordingButton> createState() =>
      _EnhancedRecordingButtonState();
}

class _EnhancedRecordingButtonState extends State<EnhancedRecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTapDown() async {
    await FeedbackService.medium();
    _controller.repeat(reverse: true);
    widget.onRecordingStart?.call();
  }

  Future<void> _handleTapUp() async {
    await FeedbackService.light();
    _controller.stop();
    widget.onRecordingStop?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.activeColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _handleTapUp(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: widget.isRecording ? _rotateAnimation.value : 0,
          child: Transform.scale(
            scale: widget.isRecording
                ? _pulseAnimation.value
                : _scaleAnimation.value,
            child: Container(
              height: widget.isRecording ? widget.size + 8 : widget.size,
              width: widget.isRecording ? widget.size + 8 : widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isRecording ? Colors.red : effectiveColor,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isRecording ? Colors.red : effectiveColor)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: widget.isRecording ? 32 : 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
