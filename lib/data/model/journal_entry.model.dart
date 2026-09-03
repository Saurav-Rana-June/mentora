class JournalEntryModel {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;
  final String? imagePath;

  JournalEntryModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    this.imagePath,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  JournalEntryModel copyWith({
    String? id,
    String? question,
    String? answer,
    DateTime? createdAt,
    String? imagePath,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
