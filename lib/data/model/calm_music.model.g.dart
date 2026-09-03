// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calm_music.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalmMusicModel _$CalmMusicModelFromJson(Map<String, dynamic> json) =>
    CalmMusicModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      duration: json['duration'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CalmMusicModelToJson(CalmMusicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'category': instance.category,
      'description': instance.description,
    };
