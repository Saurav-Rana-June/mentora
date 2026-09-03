import 'package:json_annotation/json_annotation.dart';

part 'plan.model.g.dart';

@JsonSerializable()
class PlanModel {
  int? id;
  int? activityId;
  String? title;
  String? caption;
  String? icon;
  String? duration;
  String? category;
  int? sortOrder;
  bool? isComplete;

  PlanModel({
    this.id,
    this.activityId,
    this.title,
    this.caption,
    this.icon,
    this.duration,
    this.category,
    this.sortOrder,
    this.isComplete,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);

  // Getters for UI component consumption
  String get uiTitle => (category ?? '').toUpperCase();
  String get label => title ?? '';
  String get uiCaption => '${duration ?? ''} • ${caption ?? ''}';

  String get uiIcon {
    switch (icon?.toLowerCase()) {
      case 'box':
      case 'box-breathing':
      case 'breathing':
        return '\u{f800}';
      case 'lotus':
      case 'meditation':
      case 'spa':
        return '\u{f800}';
      case 'moon':
      case 'sleep':
        return '\u{f186}';
      case 'heart':
      case 'love':
      case 'gratitude':
        return '\u{f004}';
      case 'journaling':
      case 'book':
        return '\u{f02d}';
      case 'movement':
      case 'running':
      case 'walking':
        return '\u{f70c}';
      default:
        return '\u{f800}';
    }
  }
}
