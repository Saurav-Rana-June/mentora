class DailyMoodAssessmentModel {
  int? id;
  int? userId;
  String? feeling;
  List<String>? why;
  List<String>? exactFeeling;
  String? notes;
  String? createdAt;

  DailyMoodAssessmentModel({
    this.id,
    this.userId,
    this.feeling,
    this.why,
    this.exactFeeling,
    this.notes,
    this.createdAt,
  });

  factory DailyMoodAssessmentModel.fromJson(Map<String, dynamic> json) {
    return DailyMoodAssessmentModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      feeling: json['feeling'] as String?,
      why: (json['why'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      exactFeeling: (json['exactFeeling'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String?,
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
