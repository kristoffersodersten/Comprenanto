import 'package:json_annotation/json_annotation.dart';

part 'transcription_result.g.dart';

@JsonSerializable()
class TranscriptionResult {
  final String text;
  final String language;
  final double confidence;
  final int duration; // Changed from Duration to int to match JSON serialization
  final String? errorMessage;

  TranscriptionResult({
    required this.text,
    required this.language,
    required this.confidence,
    required this.duration,
    this.errorMessage,
  });

  factory TranscriptionResult.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionResultFromJson(json);

  Map<String, dynamic> toJson() => _$TranscriptionResultToJson(this);
}