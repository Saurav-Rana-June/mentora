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

  // Educational Information
  final String? degree;
  final String? university;
  final int? graduationYear;
  final String? licenseNumber;
  final List<String>? certifications;
  final List<String>? languages;

  // Availability Information
  final List<String>? availableDays;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final List<String>? availableShifts;
  final List<int>? sessionDurations;

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
    this.degree,
    this.university,
    this.graduationYear,
    this.licenseNumber,
    this.certifications,
    this.languages,
    this.availableDays,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.availableShifts,
    this.sessionDurations,
    this.createdAt,
    this.updatedAt,
  });

  factory Expert.fromJson(Map<String, dynamic> json) =>
      _$ExpertFromJson(json);

  Map<String, dynamic> toJson() => _$ExpertToJson(this);
}
