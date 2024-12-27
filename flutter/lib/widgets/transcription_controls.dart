import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' show sin, pi;

class InteractiveLogoButton extends StatefulWidget {
  final String svgPath;
  final bool isRecording;
  final VoidCallback onTap;

  const InteractiveLogoButton({
    super.key,
    required this.svgPath,
    required this.isRecording,
    required this.onTap,
  });

  @override
  State<InteractiveLogoButton> createState() => _InteractiveLogoButtonState();
}

class _InteractiveLogoButtonState extends State<InteractiveLogoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant InteractiveLogoButton oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(60),
      splashColor: widget.isRecording
          ? Colors.blueAccent.withOpacity(0.3)
          : Colors.grey.withOpacity(0.3),
      child: AnimatedScale(
        scale: widget.isRecording ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: WaveAnimationPainter(
                waveProgress: _controller.value,
                isActive: widget.isRecording,
                color: widget.isRecording
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
              ),
              size: const Size(120, 120),
            ),
            SvgPicture.asset(
              widget.svgPath,
              height: 60,
              width: 60,
              color: widget.isRecording
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class WaveAnimationPainter extends CustomPainter {
  final double waveProgress;
  final Color color;
  final bool isActive;

  const WaveAnimationPainter({
    required this.waveProgress,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final baseline = height / 2;

    path.moveTo(0, baseline);

    for (var x = 0.0; x <= width; x++) {
      final progress = (x / width) + waveProgress;
      final y = baseline +
          sin(progress * 2.0 * pi) * 20.0 * (1 - waveProgress * 0.3);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveAnimationPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress ||
        oldDelegate.color != color ||
        oldDelegate.isActive != isActive;
  }
}