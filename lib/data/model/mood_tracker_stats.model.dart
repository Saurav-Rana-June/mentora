import 'package:json_annotation/json_annotation.dart';

part 'mood_tracker_stats.model.g.dart';

@JsonSerializable(explicitToJson: true)
class MoodTrackerStatsModel {
  List<MoodCalendarDayModel>? data;
  String? dominantMood;
  double? consistency;

  MoodTrackerStatsModel({this.data, this.dominantMood, this.consistency});

  factory MoodTrackerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MoodTrackerStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoodTrackerStatsModelToJson(this);
}

@JsonSerializable()
class MoodCalendarDayModel {
  String? date;
  String? feeling;

  MoodCalendarDayModel({this.date, this.feeling});

  factory MoodCalendarDayModel.fromJson(Map<String, dynamic> json) =>
      _$MoodCalendarDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoodCalendarDayModelToJson(this);
}
