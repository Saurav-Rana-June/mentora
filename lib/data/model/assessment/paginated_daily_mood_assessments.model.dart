import 'daily_mood_assessment.model.dart';

class PaginatedDailyMoodAssessmentsModel {
  final List<DailyMoodAssessmentModel> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;

  PaginatedDailyMoodAssessmentsModel({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  factory PaginatedDailyMoodAssessmentsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedDailyMoodAssessmentsModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DailyMoodAssessmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'page': page,
      'size': size,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }
}
