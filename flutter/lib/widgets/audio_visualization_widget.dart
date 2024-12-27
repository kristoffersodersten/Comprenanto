import 'package:flutter/material.dart';
import 'audio_wave_painter.dart';
import 'animated_logo.dart';

class AudioVisualizationWidget extends StatelessWidget {
  final bool isRecording;
  final Stream<double>? audioStream;
  final Color color;
  final double size;

  const AudioVisualizationWidget({
    super.key,
    this.isRecording = false,
    this.audioStream,
    this.color = Colors.blue,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isRecording && audioStream != null)
          StreamBuilder<double>(
            stream: audioStream,
            builder: (context, snapshot) {
              final amplitude = snapshot.data ?? 0.0;
              return CustomPaint(
                size: Size(size, size),
                painter: AudioWavePainter(
                  amplitude: amplitude,
                  color: color,
                  frequency: 2.0,
                  phase: 0.0,
                ),
              );
            },
          )
        else
          CustomPaint(
            size: Size(size, size),
            painter: AudioWavePainter(
              amplitude: 0.5,
              color: color.withOpacity(0.5),
              frequency: 1.0,
              phase: 0.0,
            ),
          ),
        AnimatedLogo(
          size: size * 0.5,
          isRecording: isRecording,
        ),
      ],
    );
  }
} 