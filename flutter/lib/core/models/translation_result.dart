import 'package:json_annotation/json_annotation.dart';

part 'translation_result.g.dart';

@JsonSerializable()
class TranslationResult {
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String? errorMessage;

  TranslationResult({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.errorMessage,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationResultToJson(this);
}