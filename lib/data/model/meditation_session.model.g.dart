// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_session.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeditationSessionModel _$MeditationSessionModelFromJson(
  Map<String, dynamic> json,
) => MeditationSessionModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  category: json['category'] as String?,
  duration: json['duration'] as String?,
  imageUrl: json['imageUrl'] as String?,
  isFeatured: json['isFeatured'] as bool?,
  description:
      json['description'] as String? ??
      "Take a deep breath and let go of external distractions. Find a comfortable position and focus on the flow of your breath. Let this guided meditation restore your inner balance and clarity.",
  soundTrack:
      json['soundTrack'] as String? ??
      "https://soundcloud.com/meditation-music/cadunia",
);

Map<String, dynamic> _$MeditationSessionModelToJson(
  MeditationSessionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'duration': instance.duration,
  'imageUrl': instance.imageUrl,
  'isFeatured': instance.isFeatured,
  'description': instance.description,
  'soundTrack': instance.soundTrack,
};
