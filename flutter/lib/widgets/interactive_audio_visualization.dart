import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_wave_painter.dart';
import 'animated_logo.dart';

class InteractiveAudioVisualization extends StatefulWidget {
  final Stream<double>? audioStream;
  final bool isRecording;
  final VoidCallback? onTapStart;
  final VoidCallback? onTapEnd;
  final Color color;

  const InteractiveAudioVisualization({
    super.key,
    this.audioStream,
    this.isRecording = false,
    this.onTapStart,
    this.onTapEnd,
    this.color = Colors.blue,
  });

  @override
  State<InteractiveAudioVisualization> createState() =>
      _InteractiveAudioVisualizationState();
}

class _InteractiveAudioVisualizationState
    extends State<InteractiveAudioVisualization> {
  Offset? _touchPosition;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _touchPosition = details.localPosition);
    widget.onTapStart?.call();
    HapticFeedback.mediumImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _touchPosition = null);
    widget.onTapEnd?.call();
    HapticFeedback.lightImpact();
  }

  void _handleTapCancel() {
    setState(() => _touchPosition = null);
    widget.onTapEnd?.call();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
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
                  size: const Size(double.infinity, 200),
                  painter: AudioWavePainter(
                    amplitude: amplitude,
                    color: widget.color,
                    frequency: 2.0,
                    phase: 0.0,
                    touchPosition: _touchPosition,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: const Size(double.infinity, 200),
              painter: AudioWavePainter(
                amplitude: 0.5,
                color: widget.color.withOpacity(0.5),
                frequency: 1.0,
                phase: 0.0,
                touchPosition: _touchPosition,
              ),
            ),
          AnimatedLogo(
            size: 100,
            isRecording: widget.isRecording,
          ),
        ],
      ),
    );
  }
}
