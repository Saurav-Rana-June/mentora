import 'package:json_annotation/json_annotation.dart';

part 'session_info.model.g.dart';

@JsonSerializable()
class SessionModalityModel {
  final String type;
  final String title;
  final String description;

  SessionModalityModel({
    required this.type,
    required this.title,
    required this.description,
  });

  factory SessionModalityModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModalityModelToJson(this);
}

@JsonSerializable()
class SessionDurationModel {
  final int minutes;
  final String subtitle;
  final double price;
  final double videoCallPrice;
  final double voiceCallPrice;

  SessionDurationModel({
    required this.minutes,
    required this.subtitle,
    required this.price,
    required this.videoCallPrice,
    required this.voiceCallPrice,
  });

  factory SessionDurationModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDurationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDurationModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SessionInfoModel {
  final List<SessionModalityModel> modalities;
  final List<SessionDurationModel> durations;

  SessionInfoModel({
    required this.modalities,
    required this.durations,
  });

  factory SessionInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoModelToJson(this);
}
