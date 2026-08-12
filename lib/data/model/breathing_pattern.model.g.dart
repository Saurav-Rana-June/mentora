// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breathing_pattern.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreathingPatternModel _$BreathingPatternModelFromJson(
  Map<String, dynamic> json,
) => BreathingPatternModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  inhale: (json['inhale'] as num?)?.toInt(),
  holdIn: (json['holdIn'] as num?)?.toInt(),
  exhale: (json['exhale'] as num?)?.toInt(),
  holdOut: (json['holdOut'] as num?)?.toInt(),
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$BreathingPatternModelToJson(
  BreathingPatternModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'inhale': instance.inhale,
  'holdIn': instance.holdIn,
  'exhale': instance.exhale,
  'holdOut': instance.holdOut,
  'icon': instance.icon,
};
