import 'package:json_annotation/json_annotation.dart';

part 'doctor_availability.model.g.dart';

@JsonSerializable()
class TimeSlot {
  final String time;
  final String period;
  final bool isAvailable;

  TimeSlot({
    required this.time,
    required this.period,
    required this.isAvailable,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DoctorAvailabilityModel {
  final List<String> availableDates;
  final List<TimeSlot> timeSlots;

  DoctorAvailabilityModel({
    required this.availableDates,
    required this.timeSlots,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorAvailabilityModelToJson(this);
}
