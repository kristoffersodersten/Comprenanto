import 'package:flutter/material.dart';
import 'dart:async';
import 'audio_wave_painter.dart';

class AudioVisualization extends StatelessWidget {
  final Stream<double> audioStream;
  final bool isRecording;
  final Color color;

  const AudioVisualization({
    super.key,
    required this.audioStream,
    required this.isRecording,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: isRecording
          ? StreamBuilder<double>(
              stream: audioStream,
              builder: (context, snapshot) {
                final level = snapshot.data ?? 0.0;
                return CustomPaint(
                  size: const Size(double.infinity, 100),
                  painter: AudioWavePainter(amplitude: level, color: color),
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}