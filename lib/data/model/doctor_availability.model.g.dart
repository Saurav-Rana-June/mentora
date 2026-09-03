// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_availability.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
  time: json['time'] as String,
  period: json['period'] as String,
  isAvailable: json['isAvailable'] as bool,
);

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
  'time': instance.time,
  'period': instance.period,
  'isAvailable': instance.isAvailable,
};

DoctorAvailabilityModel _$DoctorAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => DoctorAvailabilityModel(
  availableDates: (json['availableDates'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  timeSlots: (json['timeSlots'] as List<dynamic>)
      .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DoctorAvailabilityModelToJson(
  DoctorAvailabilityModel instance,
) => <String, dynamic>{
  'availableDates': instance.availableDates,
  'timeSlots': instance.timeSlots.map((e) => e.toJson()).toList(),
};
