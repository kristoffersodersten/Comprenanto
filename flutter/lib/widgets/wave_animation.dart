import 'package:flutter/material.dart';
import 'dart:math';

class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
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
          painter: WavePainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    const waveHeight = 20.0;
    const numberOfWaves = 3;
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height / 2);

    for (int i = 0; i < width; i++) {
      final x = i.toDouble();
      final y = height / 2 + sin((x / width * numberOfWaves * 2 * pi) + (animationValue * 2 * pi)) * waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}