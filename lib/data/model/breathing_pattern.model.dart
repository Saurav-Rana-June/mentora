import 'package:json_annotation/json_annotation.dart';

part 'breathing_pattern.model.g.dart';

@JsonSerializable()
class BreathingPatternModel {
  int? id;
  String? name;
  String? description;
  int? inhale;
  int? holdIn;
  int? exhale;
  int? holdOut;
  String? icon;

  BreathingPatternModel({
    this.id,
    this.name,
    this.description,
    this.inhale,
    this.holdIn,
    this.exhale,
    this.holdOut,
    this.icon,
  });

  int get cycleDuration => (inhale ?? 0) + (holdIn ?? 0) + (exhale ?? 0) + (holdOut ?? 0);

  factory BreathingPatternModel.fromJson(Map<String, dynamic> json) =>
      _$BreathingPatternModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreathingPatternModelToJson(this);
}
