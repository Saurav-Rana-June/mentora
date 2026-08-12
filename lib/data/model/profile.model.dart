import 'package:json_annotation/json_annotation.dart';

part 'profile.model.g.dart';

@JsonSerializable()
class ProfileModel {
  int? id;
  int? userId;
  String? name;
  String? gender;
  int? age;
  String? email;
  String? address;
  double? height;
  double? weight;
  double? bmi;
  String? phoneNumber;
  String? profilePictureUrl;
  String? createdAt;
  String? updatedAt;

  ProfileModel({
    this.id,
    this.userId,
    this.name,
    this.gender,
    this.age,
    this.email,
    this.address,
    this.height,
    this.weight,
    this.bmi,
    this.phoneNumber,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
