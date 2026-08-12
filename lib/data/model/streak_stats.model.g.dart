// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_stats.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakStatsModel _$StreakStatsModelFromJson(Map<String, dynamic> json) =>
    StreakStatsModel(
      currentStreak: (json['current_streak'] as num?)?.toInt(),
      weeklyCheckInCount: (json['weekly_checkin_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StreakStatsModelToJson(StreakStatsModel instance) =>
    <String, dynamic>{
      'current_streak': instance.currentStreak,
      'weekly_checkin_count': instance.weeklyCheckInCount,
    };
