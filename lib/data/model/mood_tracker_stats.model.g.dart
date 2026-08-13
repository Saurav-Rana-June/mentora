// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_tracker_stats.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodTrackerStatsModel _$MoodTrackerStatsModelFromJson(
  Map<String, dynamic> json,
) => MoodTrackerStatsModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => MoodCalendarDayModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  dominantMood: json['dominantMood'] as String?,
  consistency: (json['consistency'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MoodTrackerStatsModelToJson(
  MoodTrackerStatsModel instance,
) => <String, dynamic>{
  'data': instance.data?.map((e) => e.toJson()).toList(),
  'dominantMood': instance.dominantMood,
  'consistency': instance.consistency,
};

MoodCalendarDayModel _$MoodCalendarDayModelFromJson(
  Map<String, dynamic> json,
) => MoodCalendarDayModel(
  date: json['date'] as String?,
  feeling: json['feeling'] as String?,
);

Map<String, dynamic> _$MoodCalendarDayModelToJson(
  MoodCalendarDayModel instance,
) => <String, dynamic>{'date': instance.date, 'feeling': instance.feeling};
