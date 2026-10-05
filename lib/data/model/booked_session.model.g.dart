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
      bookingdate: json['bookingdate'] as String? ?? json['booking_date'] as String? ?? "",
      bookingDate: json['bookingDate'] as String? ?? json['booking_date'] as String? ?? "",
      bookingTimeslot: json['bookingTimeslot'] as String? ?? json['booking_timeslot'] as String? ?? "",
      timeSlotType: json['timeSlotType'] as String? ?? json['time_slot_type'] as String? ?? "",
      modalityType: json['modalityType'] as String? ?? json['modality_type'] as String? ?? "",
      duration: (json['duration'] as num?)?.toInt() ?? 30,
      durationCost: (json['durationCost'] as num?)?.toDouble() ?? (json['duration_cost'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      bookingStatus: json['bookingStatus'] as String? ?? json['booking_status'] as String? ?? "Pending",
      stars: (json['stars'] as num?)?.toInt(),
      review: json['review'] as String? ?? json['feedback'] as String?,
      feedback: json['feedback'] as String? ?? json['review'] as String?,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? "",
      updatedAt: json['updatedAt'] as String? ?? json['updated_at'] as String? ?? "",
      doctorName: json['doctorName'] as String? ?? json['doctor_name'] as String?,
      doctorSpeciality: json['doctorSpeciality'] as String? ?? json['doctor_speciality'] as String?,
      doctorImage: json['doctorImage'] as String? ?? json['doctor_image'] as String?,
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
      'stars': instance.stars,
      'review': instance.review,
      'feedback': instance.feedback,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'doctorName': instance.doctorName,
      'doctorSpeciality': instance.doctorSpeciality,
      'doctorImage': instance.doctorImage,
    };
