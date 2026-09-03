import 'package:json_annotation/json_annotation.dart';

part 'calm_music.model.g.dart';

@JsonSerializable()
class CalmMusicModel {
  int? id;
  String? title;
  String? duration;
  String? imageUrl;
  String? audioUrl;
  String? category;
  String? description;

  CalmMusicModel({
    this.id,
    this.title,
    this.duration,
    this.imageUrl,
    this.audioUrl,
    this.category,
    this.description,
  });

  factory CalmMusicModel.fromJson(Map<String, dynamic> json) =>
      _$CalmMusicModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalmMusicModelToJson(this);
}
