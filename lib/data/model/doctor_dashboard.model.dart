class DoctorDashboardData {
  final int doctorId;
  final String doctorName;
  final String speciality;
  final String? image;
  final bool isOnline;
  final DoctorDashboardStats stats;
  final WeeklyConsultationVolume weeklyVolume;
  final List<PatientReviewItem> recentReviews;

  DoctorDashboardData({
    required this.doctorId,
    required this.doctorName,
    required this.speciality,
    this.image,
    required this.isOnline,
    required this.stats,
    required this.weeklyVolume,
    required this.recentReviews,
  });

  factory DoctorDashboardData.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardData(
      doctorId: json['doctorId'] as int? ?? json['doctor_id'] as int? ?? 1,
      doctorName: json['doctorName'] as String? ?? json['doctor_name'] as String? ?? '',
      speciality: json['speciality'] as String? ?? '',
      image: json['image'] as String?,
      isOnline: json['isOnline'] as bool? ?? json['is_online'] as bool? ?? true,
      stats: DoctorDashboardStats.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
      weeklyVolume: WeeklyConsultationVolume.fromJson(
        json['weeklyVolume'] as Map<String, dynamic>? ??
            json['weekly_volume'] as Map<String, dynamic>? ??
            {},
      ),
      recentReviews: (json['recentReviews'] as List<dynamic>? ??
              json['recent_reviews'] as List<dynamic>? ??
              [])
          .map((e) => PatientReviewItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'speciality': speciality,
      'image': image,
      'isOnline': isOnline,
      'stats': stats.toJson(),
      'weeklyVolume': weeklyVolume.toJson(),
      'recentReviews': recentReviews.map((e) => e.toJson()).toList(),
    };
  }
}

class DoctorDashboardStats {
  final int totalPatients;
  final int totalConsultations;
  final double totalEarnings;
  final double averageRating;
  final int reviewsCount;
  final String completionRate;
  final String patientsGrowth;
  final String earningsGrowth;

  DoctorDashboardStats({
    required this.totalPatients,
    required this.totalConsultations,
    required this.totalEarnings,
    required this.averageRating,
    required this.reviewsCount,
    required this.completionRate,
    required this.patientsGrowth,
    required this.earningsGrowth,
  });

  factory DoctorDashboardStats.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardStats(
      totalPatients: json['totalPatients'] as int? ?? json['total_patients'] as int? ?? 0,
      totalConsultations: json['totalConsultations'] as int? ?? json['total_consultations'] as int? ?? 0,
      totalEarnings: (json['totalEarnings'] as num? ?? json['total_earnings'] as num? ?? 0.0).toDouble(),
      averageRating: (json['averageRating'] as num? ?? json['average_rating'] as num? ?? 5.0).toDouble(),
      reviewsCount: json['reviewsCount'] as int? ?? json['reviews_count'] as int? ?? 0,
      completionRate: json['completionRate'] as String? ?? json['completion_rate'] as String? ?? '98.4%',
      patientsGrowth: json['patientsGrowth'] as String? ?? json['patients_growth'] as String? ?? '+14 this month',
      earningsGrowth: json['earningsGrowth'] as String? ?? json['earnings_growth'] as String? ?? '+\$650 this week',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPatients': totalPatients,
      'totalConsultations': totalConsultations,
      'totalEarnings': totalEarnings,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'completionRate': completionRate,
      'patientsGrowth': patientsGrowth,
      'earningsGrowth': earningsGrowth,
    };
  }
}

class WeeklyConsultationVolume {
  final int totalWeeklySessions;
  final String completionRate;
  final int avgDurationMinutes;
  final List<WeeklyVolumeDay> dailyVolume;

  WeeklyConsultationVolume({
    required this.totalWeeklySessions,
    required this.completionRate,
    required this.avgDurationMinutes,
    required this.dailyVolume,
  });

  factory WeeklyConsultationVolume.fromJson(Map<String, dynamic> json) {
    return WeeklyConsultationVolume(
      totalWeeklySessions: json['totalWeeklySessions'] as int? ?? json['total_weekly_sessions'] as int? ?? 0,
      completionRate: json['completionRate'] as String? ?? json['completion_rate'] as String? ?? '98.4%',
      avgDurationMinutes: json['avgDurationMinutes'] as int? ?? json['avg_duration_minutes'] as int? ?? 45,
      dailyVolume: (json['dailyVolume'] as List<dynamic>? ??
              json['daily_volume'] as List<dynamic>? ??
              [])
          .map((e) => WeeklyVolumeDay.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWeeklySessions': totalWeeklySessions,
      'completionRate': completionRate,
      'avgDurationMinutes': avgDurationMinutes,
      'dailyVolume': dailyVolume.map((e) => e.toJson()).toList(),
    };
  }
}

class WeeklyVolumeDay {
  final String day;
  final String date;
  final int consultationsCount;
  final double hours;
  final double earnings;

  WeeklyVolumeDay({
    required this.day,
    required this.date,
    required this.consultationsCount,
    required this.hours,
    required this.earnings,
  });

  factory WeeklyVolumeDay.fromJson(Map<String, dynamic> json) {
    return WeeklyVolumeDay(
      day: json['day'] as String? ?? '',
      date: json['date'] as String? ?? '',
      consultationsCount: json['consultationsCount'] as int? ?? json['consultations_count'] as int? ?? 0,
      hours: (json['hours'] as num? ?? 0.0).toDouble(),
      earnings: (json['earnings'] as num? ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
      'consultationsCount': consultationsCount,
      'hours': hours,
      'earnings': earnings,
    };
  }
}

class PatientReviewItem {
  final int id;
  final int? patientId;
  final String patientName;
  final String? patientAvatar;
  final int rating;
  final String comment;
  final String timeAgo;
  final String date;
  final String? modality;

  PatientReviewItem({
    required this.id,
    this.patientId,
    required this.patientName,
    this.patientAvatar,
    required this.rating,
    required this.comment,
    required this.timeAgo,
    required this.date,
    this.modality,
  });

  factory PatientReviewItem.fromJson(Map<String, dynamic> json) {
    return PatientReviewItem(
      id: json['id'] as int? ?? 0,
      patientId: json['patientId'] as int? ?? json['patient_id'] as int?,
      patientName: json['patientName'] as String? ?? json['patient_name'] as String? ?? 'Anonymous Patient',
      patientAvatar: json['patientAvatar'] as String? ?? json['patient_avatar'] as String?,
      rating: json['rating'] as int? ?? 5,
      comment: json['comment'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? json['time_ago'] as String? ?? 'Recently',
      date: json['date'] as String? ?? '',
      modality: json['modality'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientAvatar': patientAvatar,
      'rating': rating,
      'comment': comment,
      'timeAgo': timeAgo,
      'date': date,
      'modality': modality,
    };
  }
}
