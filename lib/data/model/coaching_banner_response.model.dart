import 'package:json_annotation/json_annotation.dart';

part 'coaching_banner_response.model.g.dart';

@JsonSerializable()
class CoachingBannerResponseModel {
  String? title;
  String? description;
  String? icon;

  CoachingBannerResponseModel({
    this.title,
    this.description,
    this.icon,
  });

  factory CoachingBannerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingBannerResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoachingBannerResponseModelToJson(this);
}
