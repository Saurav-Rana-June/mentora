import 'package:json_annotation/json_annotation.dart';

part 'booked_session.model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookedSession {
  final int id;
  final int doctorId;
  final int userId;
  final String bookingdate;
  final String bookingDate;
  final String bookingTimeslot;
  final String timeSlotType;
  final String modalityType;
  final int duration;
  final double durationCost;
  final String? notes;
  final String bookingStatus;
  final String createdAt;
  final String updatedAt;
  final String? doctorName;
  final String? doctorSpeciality;
  final String? doctorImage;

  BookedSession({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.bookingdate,
    required this.bookingDate,
    required this.bookingTimeslot,
    required this.timeSlotType,
    required this.modalityType,
    required this.duration,
    required this.durationCost,
    this.notes,
    required this.bookingStatus,
    required this.createdAt,
    required this.updatedAt,
    this.doctorName,
    this.doctorSpeciality,
    this.doctorImage,
  });

  factory BookedSession.fromJson(Map<String, dynamic> json) =>
      _$BookedSessionFromJson(json);

  Map<String, dynamic> toJson() => _$BookedSessionToJson(this);
}
