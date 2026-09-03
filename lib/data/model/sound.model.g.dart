// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoundModel _$SoundModelFromJson(Map<String, dynamic> json) => SoundModel(
  id: (json['id'] as num?)?.toInt(),
  emoji: json['emoji'] as String?,
  title: json['title'] as String?,
  audioUrl: json['audioUrl'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$SoundModelToJson(SoundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'title': instance.title,
      'audioUrl': instance.audioUrl,
      'category': instance.category,
    };
