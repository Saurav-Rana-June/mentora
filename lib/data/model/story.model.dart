import 'package:json_annotation/json_annotation.dart';

part 'story.model.g.dart';

@JsonSerializable()
class StoryModel {
  int? id;
  String? title;
  String? duration;
  String? imageUrl;
  String? audioUrl;
  String? category;
  String? description;

  StoryModel({
    this.id,
    this.title,
    this.duration,
    this.imageUrl,
    this.audioUrl,
    this.category,
    this.description,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
