class DoctorAppointmentModel {
  final int id;
  final int doctorId;
  final int userId;
  final String patientName;
  final String patientImage;
  final int patientAge;
  final String patientGender;
  final String patientIssue;
  final String patientEmail;
  final String patientPhone;
  final String bookingDate;
  final String bookingTimeslot;
  final String modalityType;
  final String timeSlotType;
  final int duration;
  final double durationCost;
  final String? notes;
  final String bookingStatus;
  final String? cancellationReason;
  final String? clinicalNotes;
  final String? prescription;
  final int? stars;
  final String? review;
  final String createdAt;
  final String updatedAt;

  DoctorAppointmentModel({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.patientName,
    required this.patientImage,
    required this.patientAge,
    required this.patientGender,
    required this.patientIssue,
    required this.patientEmail,
    required this.patientPhone,
    required this.bookingDate,
    required this.bookingTimeslot,
    required this.modalityType,
    required this.timeSlotType,
    required this.duration,
    required this.durationCost,
    this.notes,
    required this.bookingStatus,
    this.cancellationReason,
    this.clinicalNotes,
    this.prescription,
    this.stars,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  DoctorAppointmentModel copyWith({
    int? id,
    int? doctorId,
    int? userId,
    String? patientName,
    String? patientImage,
    int? patientAge,
    String? patientGender,
    String? patientIssue,
    String? patientEmail,
    String? patientPhone,
    String? bookingDate,
    String? bookingTimeslot,
    String? modalityType,
    String? timeSlotType,
    int? duration,
    double? durationCost,
    String? notes,
    String? bookingStatus,
    String? cancellationReason,
    String? clinicalNotes,
    String? prescription,
    int? stars,
    String? review,
    String? createdAt,
    String? updatedAt,
  }) {
    return DoctorAppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      userId: userId ?? this.userId,
      patientName: patientName ?? this.patientName,
      patientImage: patientImage ?? this.patientImage,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      patientIssue: patientIssue ?? this.patientIssue,
      patientEmail: patientEmail ?? this.patientEmail,
      patientPhone: patientPhone ?? this.patientPhone,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTimeslot: bookingTimeslot ?? this.bookingTimeslot,
      modalityType: modalityType ?? this.modalityType,
      timeSlotType: timeSlotType ?? this.timeSlotType,
      duration: duration ?? this.duration,
      durationCost: durationCost ?? this.durationCost,
      notes: notes ?? this.notes,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      prescription: prescription ?? this.prescription,
      stars: stars ?? this.stars,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      doctorId: json['doctorId'] is int ? json['doctorId'] : int.tryParse(json['doctorId']?.toString() ?? '0') ?? 0,
      userId: json['userId'] is int ? json['userId'] : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      patientName: json['patientName']?.toString() ?? json['doctorName']?.toString() ?? 'Patient',
      patientImage: json['patientImage']?.toString() ?? json['doctorImage']?.toString() ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      patientAge: json['patientAge'] is int ? json['patientAge'] : int.tryParse(json['patientAge']?.toString() ?? '28') ?? 28,
      patientGender: json['patientGender']?.toString() ?? 'Not specified',
      patientIssue: json['patientIssue']?.toString() ?? json['notes']?.toString() ?? 'General Consultation & Wellbeing Assessment',
      patientEmail: json['patientEmail']?.toString() ?? 'patient@mentora.com',
      patientPhone: json['patientPhone']?.toString() ?? '+1 (555) 234-5678',
      bookingDate: json['bookingDate']?.toString() ?? json['bookingdate']?.toString() ?? DateTime.now().toIso8601String().split('T').first,
      bookingTimeslot: json['bookingTimeslot']?.toString() ?? '10:00 AM',
      modalityType: json['modalityType']?.toString() ?? 'Video Call',
      timeSlotType: json['timeSlotType']?.toString() ?? 'Morning',
      duration: json['duration'] is int ? json['duration'] : int.tryParse(json['duration']?.toString() ?? '45') ?? 45,
      durationCost: (json['durationCost'] is num) ? (json['durationCost'] as num).toDouble() : double.tryParse(json['durationCost']?.toString() ?? '85.0') ?? 85.0,
      notes: json['notes']?.toString(),
      bookingStatus: json['bookingStatus']?.toString() ?? 'Upcoming',
      cancellationReason: json['cancellationReason']?.toString(),
      clinicalNotes: json['clinicalNotes']?.toString(),
      prescription: json['prescription']?.toString(),
      stars: json['stars'] is int ? json['stars'] : int.tryParse(json['stars']?.toString() ?? ''),
      review: json['review']?.toString(),
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'patientName': patientName,
      'patientImage': patientImage,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'patientIssue': patientIssue,
      'patientEmail': patientEmail,
      'patientPhone': patientPhone,
      'bookingDate': bookingDate,
      'bookingTimeslot': bookingTimeslot,
      'modalityType': modalityType,
      'timeSlotType': timeSlotType,
      'duration': duration,
      'durationCost': durationCost,
      'notes': notes,
      'bookingStatus': bookingStatus,
      'cancellationReason': cancellationReason,
      'clinicalNotes': clinicalNotes,
      'prescription': prescription,
      'stars': stars,
      'review': review,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
