import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/services/transcription_service.dart';
import '../core/services/audio_service.dart';
import '../core/interaction/feedback_system.dart';
import 'package:provider/provider.dart';
import 'audio_wave_painter.dart'; // Import the correct file for AudioWavePainter

class EnhancedAudioRecordingButton extends StatefulWidget {
  final Stream<double>? audioStream;
  final double size;
  final Color? activeColor;
  final Color? recordingColor;
  
  const EnhancedAudioRecordingButton({
    super.key,
    this.audioStream,
    this.size = 64,
    this.activeColor,
    this.recordingColor,
  });

  @override
  State<EnhancedAudioRecordingButton> createState() => _EnhancedAudioRecordingButtonState();
}

class _EnhancedAudioRecordingButtonState extends State<EnhancedAudioRecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TranscriptionService, AudioService>(
      builder: (context, transcriptionService, audioService, _) {
        final isRecording = audioService.currentState == AudioState.recording;
        final effectiveColor = widget.activeColor ?? CupertinoColors.activeBlue;
        final effectiveRecordingColor = widget.recordingColor ?? CupertinoColors.destructiveRed;

        return GestureDetector(
          onTapDown: (_) => _handleRecordingStart(context, transcriptionService),
          onTapUp: (_) => _handleRecordingStop(context, transcriptionService),
          onTapCancel: () => _handleRecordingStop(context, transcriptionService),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isRecording && widget.audioStream != null)
                StreamBuilder<double>(
                  stream: widget.audioStream,
                  builder: (context, snapshot) {
                    return CustomPaint(
                      size: Size(widget.size * 1.5, widget.size * 1.5),
                      painter: AudioWavePainter(
                        amplitude: snapshot.data ?? 0.5,
                        color: effectiveRecordingColor,
                        phase: _waveAnimation.value,
                      ),
                    );
                  },
                ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Transform.scale(
                  scale: isRecording ? _pulseAnimation.value : _scaleAnimation.value,
                  child: Container(
                    height: isRecording ? widget.size + 8 : widget.size,
                    width: isRecording ? widget.size + 8 : widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? effectiveRecordingColor : effectiveColor,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? effectiveRecordingColor : effectiveColor)
                              .withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isRecording 
                          ? CupertinoIcons.stop_fill 
                          : CupertinoIcons.mic_fill,
                      color: CupertinoColors.white,
                      size: isRecording ? 32 : 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleRecordingStart(
    BuildContext context, 
    TranscriptionService service,
  ) async {
    InteractiveFeedback.buttonPress();
    _controller.repeat(reverse: true);
    await service.startTranscription();
  }

  Future<void> _handleRecordingStop(
    BuildContext context, 
    TranscriptionService service,
  ) async {
    InteractiveFeedback.success();
    _controller.stop();
    await service.stopTranscription();
    
    if (service.transcription.isNotEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transkribering klar')),
      );
    }
  }
} 