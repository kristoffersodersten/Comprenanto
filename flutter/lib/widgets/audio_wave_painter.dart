import 'package:flutter/material.dart';
import 'dart:math' show sin, pi, cos, min, max;

class AudioWavePainter extends CustomPainter {
  final double amplitude;
  final Color color;
  final double phase;
  final double frequency;
  final int waveCount;
  final bool isActive;

  const AudioWavePainter({
    required this.amplitude,
    required this.color,
    this.phase = 0.0,
    this.frequency = 2.0,
    this.waveCount = 3,
    this.isActive = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(isActive ? 0.6 : 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    for (var i = 0; i < waveCount; i++) {
      final wavePhase = phase + (i * pi / waveCount);
      _drawWaveCircle(
        canvas, 
        center, 
        radius * (0.8 + (i * 0.1)), 
        paint,
        wavePhase,
      );
    }

    // Draw center dot
    canvas.drawCircle(
      center,
      4.0,
      paint..style = PaintingStyle.fill,
    );
  }

  void _drawWaveCircle(
    Canvas canvas, 
    Offset center, 
    double radius, 
    Paint paint,
    double wavePhase,
  ) {
    final path = Path();
    final points = 100;
    final angleStep = (2 * pi) / points;
    
    path.moveTo(
      center.dx + _getWaveOffset(0, radius, wavePhase) * cos(0),
      center.dy + _getWaveOffset(0, radius, wavePhase) * sin(0),
    );

    for (var i = 1; i <= points; i++) {
      final angle = i * angleStep;
      final x = center.dx + _getWaveOffset(angle, radius, wavePhase) * cos(angle);
      final y = center.dy + _getWaveOffset(angle, radius, wavePhase) * sin(angle);
      
      if (i == 1) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  double _getWaveOffset(double angle, double radius, double wavePhase) {
    final normalizedAmplitude = max(0.1, amplitude);
    final wave = sin(angle * frequency + wavePhase) * normalizedAmplitude * 10;
    return radius + wave;
  }

  @override
  bool shouldRepaint(covariant AudioWavePainter oldDelegate) {
    return oldDelegate.amplitude != amplitude ||
        oldDelegate.color != color ||
        oldDelegate.phase != phase ||
        oldDelegate.frequency != frequency ||
        oldDelegate.waveCount != waveCount ||
        oldDelegate.isActive != isActive;
  }
}

class AudioLevelPainter extends CustomPainter {
  final double level;
  final Color color;
  final int barCount;
  final double spacing;

  const AudioLevelPainter({
    required this.level,
    required this.color,
    this.barCount = 32,
    this.spacing = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barWidth = (size.width - (spacing * (barCount - 1))) / barCount;
    final maxBarHeight = size.height * 0.8;

    for (var i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);
      final normalizedIndex = i / barCount;
      final barHeight = _calculateBarHeight(normalizedIndex, maxBarHeight);
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          (size.height - barHeight) / 2,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );
      
      canvas.drawRRect(rect, paint);
    }
  }

  double _calculateBarHeight(double normalizedIndex, double maxHeight) {
    final baseHeight = maxHeight * 0.2;
    final dynamicHeight = maxHeight * 0.8;
    
    final amplitude = sin(normalizedIndex * pi) * level;
    return baseHeight + (dynamicHeight * amplitude);
  }

  @override
  bool shouldRepaint(covariant AudioLevelPainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.color != color ||
        oldDelegate.barCount != barCount ||
        oldDelegate.spacing != spacing;
  }
}

// Animated version that handles the animation state
class AnimatedAudioWave extends StatefulWidget {
  final Color color;
  final double amplitude;
  final Duration duration;

  const AnimatedAudioWave({
    super.key,
    this.color = Colors.blue,
    this.amplitude = 1.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedAudioWave> createState() => _AnimatedAudioWaveState();
}

class _AnimatedAudioWaveState extends State<AnimatedAudioWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _phaseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _phaseAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: AudioWavePainter(
            amplitude: widget.amplitude,
            color: widget.color,
            frequency: 2.0,
            phase: _phaseAnimation.value,
          ),
          size: const Size(double.infinity, 100),
        );
      },
    );
  }
} 