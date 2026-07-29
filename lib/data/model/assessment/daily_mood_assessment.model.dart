class DailyMoodAssessmentModel {
  final int id;
  final int userId;
  final String feeling;
  final List<String> why;
  final List<String> exactFeeling;
  final String? notes;
  final String createdAt;

  DailyMoodAssessmentModel({
    required this.id,
    required this.userId,
    required this.feeling,
    required this.why,
    required this.exactFeeling,
    this.notes,
    required this.createdAt,
  });

  factory DailyMoodAssessmentModel.fromJson(Map<String, dynamic> json) {
    return DailyMoodAssessmentModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      feeling: json['feeling'] as String,
      why: (json['why'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      exactFeeling: (json['exactFeeling'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'feeling': feeling,
      'why': why,
      'exactFeeling': exactFeeling,
      'notes': notes,
      'createdAt': createdAt,
    };
  }
}
