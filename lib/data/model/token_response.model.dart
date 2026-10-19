import 'package:json_annotation/json_annotation.dart';

part 'token_response.model.g.dart';

@JsonSerializable()
class TokenResponseModel {
  String? accessToken;
  String? tokenType;
  int? doctorId;
  String? doctorName;

  TokenResponseModel({
    this.accessToken,
    this.tokenType,
    this.doctorId,
    this.doctorName,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseModelToJson(this);
}
