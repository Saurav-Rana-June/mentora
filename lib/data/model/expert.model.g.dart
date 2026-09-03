// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expert.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expert _$ExpertFromJson(Map<String, dynamic> json) => Expert(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  speciality: json['speciality'] as String?,
  image: json['image'] as String?,
  callFeature: json['callFeature'] as bool?,
  videoCallFeature: json['videoCallFeature'] as bool?,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewsCount: (json['reviewsCount'] as num?)?.toInt(),
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  patientsCount: (json['patientsCount'] as num?)?.toInt(),
  bio: json['bio'] as String?,
  startingPricePerHour: (json['startingPricePerHour'] as num?)?.toDouble(),
  specialties: (json['specialties'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isAvailable: json['isAvailable'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ExpertToJson(Expert instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'speciality': instance.speciality,
  'image': instance.image,
  'callFeature': instance.callFeature,
  'videoCallFeature': instance.videoCallFeature,
  'rating': instance.rating,
  'reviewsCount': instance.reviewsCount,
  'experienceYears': instance.experienceYears,
  'patientsCount': instance.patientsCount,
  'bio': instance.bio,
  'startingPricePerHour': instance.startingPricePerHour,
  'specialties': instance.specialties,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
