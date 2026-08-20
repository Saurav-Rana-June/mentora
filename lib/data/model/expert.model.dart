import 'package:json_annotation/json_annotation.dart';

part 'expert.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Expert {
  final int? id;
  final String? name;
  final String? speciality;
  final String? image;
  final bool? callFeature;
  final bool? videoCallFeature;
  final double? rating;
  final int? reviewsCount;
  final int? experienceYears;
  final int? patientsCount;
  final String? bio;
  final double? startingPricePerHour;
  final List<String>? specialties;
  final bool? isAvailable;
  final String? createdAt;
  final String? updatedAt;

  Expert({
    this.id,
    this.name,
    this.speciality,
    this.image,
    this.callFeature,
    this.videoCallFeature,
    this.rating,
    this.reviewsCount,
    this.experienceYears,
    this.patientsCount,
    this.bio,
    this.startingPricePerHour,
    this.specialties,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory Expert.fromJson(Map<String, dynamic> json) =>
      _$ExpertFromJson(json);

  Map<String, dynamic> toJson() => _$ExpertToJson(this);
}
