// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  name: json['name'] as String?,
  gender: json['gender'] as String?,
  age: (json['age'] as num?)?.toInt(),
  email: json['email'] as String?,
  address: json['address'] as String?,
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  bmi: (json['bmi'] as num?)?.toDouble(),
  phoneNumber: json['phoneNumber'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'gender': instance.gender,
      'age': instance.age,
      'email': instance.email,
      'address': instance.address,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'phoneNumber': instance.phoneNumber,
      'profilePictureUrl': instance.profilePictureUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
