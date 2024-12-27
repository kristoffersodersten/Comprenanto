import 'package:flutter/material.dart';
import 'dart:math' show sin, pi;

class AnimatedWaveIndicator extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double height;
  final int waveCount;
  final Duration duration;

  const AnimatedWaveIndicator({
    super.key,
    this.isActive = false,
    this.color = Colors.blue,
    this.height = 60.0,
    this.waveCount = 3,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedWaveIndicator> createState() => _AnimatedWaveIndicatorState();
}

class _AnimatedWaveIndicatorState extends State<AnimatedWaveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveProgress;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _waveProgress = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.7),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 0.3),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedWaveIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
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
          size: Size(double.infinity, widget.height),
          painter: WaveAnimationPainter(
            progress: _waveProgress.value,
            opacity: _opacityAnimation.value,
            color: widget.color,
            waveCount: widget.waveCount,
            isActive: widget.isActive,
          ),
        );
      },
    );
  }
}

class WaveAnimationPainter extends CustomPainter {
  final double progress;
  final double opacity;
  final Color color;
  final int waveCount;
  final bool isActive;

  const WaveAnimationPainter({
    required this.progress,
    required this.opacity,
    required this.color,
    required this.waveCount,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final dx = size.width / (50 * waveCount);
    var startPoint = true;

    for (var x = 0.0; x < size.width; x += dx) {
      final normalizedX = x / size.width * 2 * pi * waveCount;
      final amplitude = isActive ? 0.5 : 0.2;
      final y = size.height / 2 + 
                sin(normalizedX + progress) * 
                size.height * amplitude;

      if (startPoint) {
        path.moveTo(x, y);
        startPoint = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw reflection
    final reflectionPaint = Paint()
      ..color = color.withOpacity(opacity * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path.shift(Offset(0, 4)), reflectionPaint);
  }

  @override
  bool shouldRepaint(WaveAnimationPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.opacity != opacity ||
           oldDelegate.color != color ||
           oldDelegate.isActive != isActive;
  }
} 