// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
  id: (json['id'] as num?)?.toInt(),
  activityId: (json['activityId'] as num?)?.toInt(),
  title: json['title'] as String?,
  caption: json['caption'] as String?,
  icon: json['icon'] as String?,
  duration: json['duration'] as String?,
  category: json['category'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  isComplete: json['isComplete'] as bool?,
);

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
  'id': instance.id,
  'activityId': instance.activityId,
  'title': instance.title,
  'caption': instance.caption,
  'icon': instance.icon,
  'duration': instance.duration,
  'category': instance.category,
  'sortOrder': instance.sortOrder,
  'isComplete': instance.isComplete,
};
