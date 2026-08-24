// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_session.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookedSession _$BookedSessionFromJson(Map<String, dynamic> json) =>
    BookedSession(
      id: (json['id'] as num).toInt(),
      doctorId: (json['doctorId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      bookingdate: json['bookingdate'] as String,
      bookingDate: json['bookingDate'] as String,
      bookingTimeslot: json['bookingTimeslot'] as String,
      timeSlotType: json['timeSlotType'] as String,
      modalityType: json['modalityType'] as String,
      duration: (json['duration'] as num).toInt(),
      durationCost: (json['durationCost'] as num).toDouble(),
      notes: json['notes'] as String?,
      bookingStatus: json['bookingStatus'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      doctorName: json['doctorName'] as String?,
      doctorSpeciality: json['doctorSpeciality'] as String?,
      doctorImage: json['doctorImage'] as String?,
    );

Map<String, dynamic> _$BookedSessionToJson(BookedSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'userId': instance.userId,
      'bookingdate': instance.bookingdate,
      'bookingDate': instance.bookingDate,
      'bookingTimeslot': instance.bookingTimeslot,
      'timeSlotType': instance.timeSlotType,
      'modalityType': instance.modalityType,
      'duration': instance.duration,
      'durationCost': instance.durationCost,
      'notes': instance.notes,
      'bookingStatus': instance.bookingStatus,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'doctorName': instance.doctorName,
      'doctorSpeciality': instance.doctorSpeciality,
      'doctorImage': instance.doctorImage,
    };
