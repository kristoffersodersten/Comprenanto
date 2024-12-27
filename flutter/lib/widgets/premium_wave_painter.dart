import 'package:flutter/material.dart';
import 'dart:math' show sin, pi;

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
    final wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final reflectionPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final dx = size.width / (50 * waveCount);
    var startPoint = true;

    // Draw main wave
    for (var x = 0.0; x < size.width; x += dx) {
      final normalizedX = x / size.width * 2 * pi * waveCount;
      final y = size.height / 2 + 
               sin(normalizedX + progress) * 
               amplitude * size.height / 3 *
               (isActive ? 1.0 : 0.5);

      if (startPoint) {
        path.moveTo(x, y);
        startPoint = false;
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw main wave
    canvas.drawPath(path, wavePaint);

    // Draw reflection
    canvas.drawPath(
      path.shift(Offset(0, 4)), 
      reflectionPaint,
    );

    // Draw highlight points at peaks
    if (isActive) {
      final highlightPaint = Paint()
        ..color = color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      for (var x = 0.0; x < size.width; x += dx * 4) {
        final normalizedX = x / size.width * 2 * pi * waveCount;
        final y = size.height / 2 + 
                 sin(normalizedX + progress) * 
                 amplitude * size.height / 3;

        canvas.drawCircle(
          Offset(x, y),
          2.0,
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PremiumWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.amplitude != amplitude ||
           oldDelegate.color != color ||
           oldDelegate.waveCount != waveCount ||
           oldDelegate.isActive != isActive;
  }
} 