import 'package:json_annotation/json_annotation.dart';

part 'daily_mood_assessment.model.g.dart';

@JsonSerializable()
class DailyMoodAssessmentModel {
  int? id;
  int? userId;
  String? feeling;
  List<String>? why;
  List<String>? exactFeeling;
  String? notes;
  String? createdAt;

  DailyMoodAssessmentModel({
    this.id,
    this.userId,
    this.feeling,
    this.why,
    this.exactFeeling,
    this.notes,
    this.createdAt,
  });

  factory DailyMoodAssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$DailyMoodAssessmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMoodAssessmentModelToJson(this);
}
