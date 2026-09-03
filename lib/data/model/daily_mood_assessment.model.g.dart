// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_mood_assessment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMoodAssessmentModel _$DailyMoodAssessmentModelFromJson(
  Map<String, dynamic> json,
) => DailyMoodAssessmentModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  feeling: json['feeling'] as String?,
  why: (json['why'] as List<dynamic>?)?.map((e) => e as String).toList(),
  exactFeeling: (json['exactFeeling'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$DailyMoodAssessmentModelToJson(
  DailyMoodAssessmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'feeling': instance.feeling,
  'why': instance.why,
  'exactFeeling': instance.exactFeeling,
  'notes': instance.notes,
  'createdAt': instance.createdAt,
};
