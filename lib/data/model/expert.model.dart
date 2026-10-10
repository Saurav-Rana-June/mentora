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

  Expert copyWith({
    int? id,
    String? name,
    String? speciality,
    String? image,
    bool? callFeature,
    bool? videoCallFeature,
    double? rating,
    int? reviewsCount,
    int? experienceYears,
    int? patientsCount,
    String? bio,
    double? startingPricePerHour,
    List<String>? specialties,
    bool? isAvailable,
    String? degree,
    String? university,
    int? graduationYear,
    String? licenseNumber,
    List<String>? certifications,
    List<String>? languages,
    List<String>? availableDays,
    String? workingHoursStart,
    String? workingHoursEnd,
    List<String>? availableShifts,
    List<int>? sessionDurations,
    String? createdAt,
    String? updatedAt,
  }) {
    return Expert(
      id: id ?? this.id,
      name: name ?? this.name,
      speciality: speciality ?? this.speciality,
      image: image ?? this.image,
      callFeature: callFeature ?? this.callFeature,
      videoCallFeature: videoCallFeature ?? this.videoCallFeature,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      experienceYears: experienceYears ?? this.experienceYears,
      patientsCount: patientsCount ?? this.patientsCount,
      bio: bio ?? this.bio,
      startingPricePerHour: startingPricePerHour ?? this.startingPricePerHour,
      specialties: specialties ?? this.specialties,
      isAvailable: isAvailable ?? this.isAvailable,
      degree: degree ?? this.degree,
      university: university ?? this.university,
      graduationYear: graduationYear ?? this.graduationYear,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      availableDays: availableDays ?? this.availableDays,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      availableShifts: availableShifts ?? this.availableShifts,
      sessionDurations: sessionDurations ?? this.sessionDurations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
