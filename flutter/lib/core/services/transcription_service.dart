import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import 'audio_service.dart';
import 'middleware_service.dart';

enum TranscriptionState { idle, transcribing, error }

class TranscriptionService extends ChangeNotifier {
  final AudioService _audioService;
  final MiddlewareService _middlewareService;
  
  TranscriptionState _state = TranscriptionState.idle;
  String _transcription = '';
  String? _errorMessage;
  
  TranscriptionService(this._audioService, this._middlewareService) {
    _initializeListeners();
  }

  // Public getters
  TranscriptionState get state => _state;
  String get transcription => _transcription;
  String? get errorMessage => _errorMessage;

  void _initializeListeners() {
    _audioService.addListener(() {
      if (_audioService.currentState == AudioState.error) {
        _handleError(_audioService.errorMessage ?? 'Unknown audio error');
      }
    });
  }

  Future<void> startTranscription() async {
    try {
      if (_state == TranscriptionState.transcribing) return;
      
      _state = TranscriptionState.transcribing;
      _errorMessage = null;
      notifyListeners();

      await _audioService.startRecording();
      
      AppLogger.info('Started transcription process');
    } catch (e) {
      _handleError('Failed to start transcription: $e');
    }
  }

  Future<void> stopTranscription() async {
    try {
      if (_state != TranscriptionState.transcribing) return;

      await _audioService.stopRecording();
      
      final result = await _middlewareService.transcribeAudio(
        // Add audio data here when implemented
        audioData: [], 
      );
      
      _transcription = result.text;
      _state = TranscriptionState.idle;
      notifyListeners();
      
      AppLogger.info('Completed transcription');
    } catch (e) {
      _handleError('Failed to complete transcription: $e');
    }
  }

  void clearTranscription() {
    _transcription = '';
    _errorMessage = null;
    _state = TranscriptionState.idle;
    notifyListeners();
  }

  void _handleError(String message) {
    _state = TranscriptionState.error;
    _errorMessage = message;
    AppLogger.error(message);
    notifyListeners();
  }

  @override
  void dispose() {
    // Cleanup if needed
    super.dispose();
  }
}