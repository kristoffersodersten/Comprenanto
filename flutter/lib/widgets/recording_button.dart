import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final bool isRecording;

  const RecordingButton({
    super.key,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isRecording ? onStopRecording : onStartRecording,
      child: Text(isRecording ? 'Stop' : 'Record'),
    );
  }
} 