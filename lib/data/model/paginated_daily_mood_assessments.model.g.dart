// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_daily_mood_assessments.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedDailyMoodAssessmentsModel _$PaginatedDailyMoodAssessmentsModelFromJson(
  Map<String, dynamic> json,
) => PaginatedDailyMoodAssessmentsModel(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => DailyMoodAssessmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginatedDailyMoodAssessmentsModelToJson(
  PaginatedDailyMoodAssessmentsModel instance,
) => <String, dynamic>{
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'page': instance.page,
  'size': instance.size,
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
};
