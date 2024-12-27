import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';

enum AudioState { idle, recording, processing, error }

class AudioService extends ChangeNotifier {
  AudioState _currentState = AudioState.idle;
  String? _errorMessage;
  final _audioLevelController = StreamController<double>.broadcast();
  Timer? _audioLevelTimer;

  AudioState get currentState => _currentState;
  String? get errorMessage => _errorMessage;
  Stream<double> get audioLevelStream => _audioLevelController.stream;

  Future<void> startRecording() async {
    if (_currentState == AudioState.recording) return;
    try {
      _currentState = AudioState.recording;
      notifyListeners();

      _startAudioLevelSimulation();

      AppLogger.info('Started recording audio');
    } catch (e) {
      _handleError('Failed to start recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (_currentState != AudioState.recording) return;
    try {
      _currentState = AudioState.processing;
      notifyListeners();

      _stopAudioLevelSimulation();

      // Simulate processing delay
      final processingDelay = AppConfig.apiTimeout;
      if (processingDelay is int) {
        await Future.delayed(Duration(milliseconds: processingDelay as int));
      } else {
        _handleError('Invalid processing delay type');
        return;
      }

      _currentState = AudioState.idle;
      notifyListeners();

      AppLogger.info('Stopped recording audio');
    } catch (e) {
      _handleError('Failed to stop recording: $e');
    }
  }

  void _startAudioLevelSimulation() {
    _audioLevelTimer?.cancel();
    _audioLevelTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        final level = 0.3 + (DateTime.now().millisecondsSinceEpoch % 1000) / 1000 * 0.7;
        _audioLevelController.add(level);
      },
    );
  }

  void _stopAudioLevelSimulation() {
    _audioLevelTimer?.cancel();
    _audioLevelTimer = null;
  }

  void _handleError(String message) {
    _currentState = AudioState.error;
    _errorMessage = message;
    _stopAudioLevelSimulation();
    AppLogger.error(message);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioLevelTimer?.cancel();
    _audioLevelController.close();
    super.dispose();
  }
}