class JournalQuestionModel {
  final int id;
  final String questionText;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalQuestionModel({
    required this.id,
    required this.questionText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalQuestionModel.fromJson(Map<String, dynamic> json) {
    return JournalQuestionModel(
      id: json['id'] as int,
      questionText: json['questionText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
