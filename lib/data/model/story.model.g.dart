// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  duration: json['duration'] as String?,
  imageUrl: json['imageUrl'] as String?,
  audioUrl: json['audioUrl'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'category': instance.category,
      'description': instance.description,
    };
