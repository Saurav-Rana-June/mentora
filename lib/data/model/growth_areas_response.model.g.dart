// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_areas_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrowthAreasResponseModel _$GrowthAreasResponseModelFromJson(
  Map<String, dynamic> json,
) => GrowthAreasResponseModel(
  hasSufficientData: json['hasSufficientData'] as bool?,
  areas: (json['areas'] as List<dynamic>?)
      ?.map((e) => GrowthAreaModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  placeholderMessage: json['placeholderMessage'] as String?,
);

Map<String, dynamic> _$GrowthAreasResponseModelToJson(
  GrowthAreasResponseModel instance,
) => <String, dynamic>{
  'hasSufficientData': instance.hasSufficientData,
  'areas': instance.areas?.map((e) => e.toJson()).toList(),
  'placeholderMessage': instance.placeholderMessage,
};

GrowthAreaModel _$GrowthAreaModelFromJson(Map<String, dynamic> json) =>
    GrowthAreaModel(
      title: json['title'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      tip: json['tip'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$GrowthAreaModelToJson(GrowthAreaModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'progress': instance.progress,
      'tip': instance.tip,
      'icon': instance.icon,
    };
