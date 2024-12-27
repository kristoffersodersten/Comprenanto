import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TranscriptionNotifier extends ChangeNotifier {
  final TextEditingController transcriptionController = TextEditingController();
  final ApiService _apiService;
  bool _isProcessing = false;

  TranscriptionNotifier(this._apiService);

  bool get isProcessing => _isProcessing;

  Future<void> startTranscription(String audioData) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final response =
          await _apiService.post('/transcription', {'audio': audioData});
      transcriptionController.text = response['transcription'];
    } catch (e) {
      debugPrint('Transkribering misslyckades: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String get cleanupText {
    // Implement your cleanup logic here
    return transcriptionController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}