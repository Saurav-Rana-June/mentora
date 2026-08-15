import 'package:json_annotation/json_annotation.dart';

part 'meditation_session.model.g.dart';

@JsonSerializable()
class MeditationSessionModel {
  int? id;
  String? title;
  String? category;
  String? duration;
  String? imageUrl;
  bool? isFeatured;
  String? description;
  String? soundTrack;

  MeditationSessionModel({
    this.id,
    this.title,
    this.category,
    this.duration,
    this.imageUrl,
    this.isFeatured,
    this.description =
        "Take a deep breath and let go of external distractions. Find a comfortable position and focus on the flow of your breath. Let this guided meditation restore your inner balance and clarity.",
    this.soundTrack = "https://soundcloud.com/meditation-music/cadunia",
  });

  factory MeditationSessionModel.fromJson(Map<String, dynamic> json) =>
      _$MeditationSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeditationSessionModelToJson(this);
}
