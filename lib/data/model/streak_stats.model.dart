import 'package:json_annotation/json_annotation.dart';

part 'streak_stats.model.g.dart';

@JsonSerializable()
class StreakStatsModel {
  @JsonKey(name: 'current_streak')
  int? currentStreak;
  
  @JsonKey(name: 'weekly_checkin_count')
  int? weeklyCheckInCount;

  StreakStatsModel({
    this.currentStreak,
    this.weeklyCheckInCount,
  });

  factory StreakStatsModel.fromJson(Map<String, dynamic> json) =>
      _$StreakStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreakStatsModelToJson(this);
}
