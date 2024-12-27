import 'package:flutter/material.dart';
import 'dart:math' show sin, pi;
import 'package:flutter/services.dart';

class PremiumWaveAnimation extends StatefulWidget {
  final Color? color;
  final double height;
  final bool isActive;
  final int waveCount;
  final Duration duration;
  final VoidCallback? onTap;

  const PremiumWaveAnimation({
    super.key,
    this.color,
    this.height = 60,
    this.isActive = false,
    this.waveCount = 3,
    this.duration = const Duration(seconds: 2),
    this.onTap,
  });

  @override
  State<PremiumWaveAnimation> createState() => _PremiumWaveAnimationState();
}

class _PremiumWaveAnimationState extends State<PremiumWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _amplitudeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _amplitudeAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PremiumWaveAnimation oldWidget) {
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
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTapDown: (_) => HapticFeedback.lightImpact(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(double.infinity, widget.height),
            painter: PremiumWavePainter(
              progress: _progressAnimation.value,
              amplitude: _amplitudeAnimation.value,
              color: effectiveColor,
              waveCount: widget.waveCount,
              isActive: widget.isActive,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PremiumWavePainter extends CustomPainter {
  final double progress;
  final double amplitude;
  final Color color;
  final int waveCount;
  final bool isActive;

  PremiumWavePainter({
    required this.progress,
    required this.amplitude,
    required this.color,
    required this.waveCount,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < waveCount; i++) {
      final waveProgress = progress + (i * 2 * pi / waveCount);
      final waveHeight = amplitude * size.height / 2;
      final waveWidth = size.width / waveCount;

      path.moveTo(i * waveWidth, size.height / 2);
      for (double x = 0; x <= waveWidth; x++) {
        final y = waveHeight * sin((x / waveWidth) * 2 * pi + waveProgress);
        path.lineTo(i * waveWidth + x, size.height / 2 + y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return isActive;
  }
}