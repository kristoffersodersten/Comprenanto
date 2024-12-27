// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranscriptionResult _$TranscriptionResultFromJson(Map<String, dynamic> json) =>
    TranscriptionResult(
      text: json['text'] as String,
      language: json['language'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$TranscriptionResultToJson(
        TranscriptionResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'language': instance.language,
      'confidence': instance.confidence,
      'duration': instance.duration,
      'errorMessage': instance.errorMessage,
    };
