import 'package:json_annotation/json_annotation.dart';

part 'sound.model.g.dart';

@JsonSerializable()
class SoundModel {
  int? id;
  String? emoji;
  String? title;
  String? audioUrl;
  String? category;

  SoundModel({
    this.id,
    this.emoji,
    this.title,
    this.audioUrl,
    this.category,
  });

  factory SoundModel.fromJson(Map<String, dynamic> json) =>
      _$SoundModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoundModelToJson(this);
}
