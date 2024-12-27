import 'package:flutter/material.dart';
import '../core/interaction/feedback_system.dart';
import 'audio_wave_painter.dart';

class AudioRecordingButton extends StatefulWidget {
  final Stream<double>? audioStream;
  final bool isRecording;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;
  final Color? activeColor;
  final double size;

  const AudioRecordingButton({
    super.key,
    this.audioStream,
    this.isRecording = false,
    this.onRecordingStart,
    this.onRecordingStop,
    this.activeColor,
    this.size = 64,
  });

  @override
  State<AudioRecordingButton> createState() => _AudioRecordingButtonState();
}

class _AudioRecordingButtonState extends State<AudioRecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  Offset? _touchPosition;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));


    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AudioRecordingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRecording && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _touchPosition = details.localPosition);
    InteractiveFeedback.buttonPress();
    widget.onRecordingStart?.call();
    _controller.repeat();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _touchPosition = null);
    InteractiveFeedback.success();
    widget.onRecordingStop?.call();
    _controller.stop();
  }

  void _handleTapCancel() {
    setState(() => _touchPosition = null);
    widget.onRecordingStop?.call();
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.activeColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.isRecording && widget.audioStream != null)
            StreamBuilder<double>(
              stream: widget.audioStream,
              builder: (context, snapshot) {
                final amplitude = snapshot.data ?? 0.0;
                return CustomPaint(
                  size: Size(widget.size * 1.5, widget.size * 1.5),
                  painter: AudioWavePainter(
                    amplitude: amplitude,
                    color: effectiveColor,
                    phase: _waveAnimation.value,
                  ),
                );
              },
            ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.scale(
              scale: widget.isRecording ? _scaleAnimation.value : 1.0,
              child: Container(
                height: widget.size,
                width: widget.size,
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
        ],
      ),
    );
  }
}