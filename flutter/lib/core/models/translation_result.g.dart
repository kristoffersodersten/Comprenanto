// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationResult _$TranslationResultFromJson(Map<String, dynamic> json) =>
    TranslationResult(
      sourceText: json['sourceText'] as String,
      translatedText: json['translatedText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$TranslationResultToJson(TranslationResult instance) =>
    <String, dynamic>{
      'sourceText': instance.sourceText,
      'translatedText': instance.translatedText,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
      'errorMessage': instance.errorMessage,
    };
