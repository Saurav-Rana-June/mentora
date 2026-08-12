import 'package:json_annotation/json_annotation.dart';
import 'daily_mood_assessment.model.dart';

part 'paginated_daily_mood_assessments.model.g.dart';

@JsonSerializable()
class PaginatedDailyMoodAssessmentsModel {
  List<DailyMoodAssessmentModel>? items;
  int? page;
  int? size;
  int? totalItems;
  int? totalPages;

  PaginatedDailyMoodAssessmentsModel({
    this.items,
    this.page,
    this.size,
    this.totalItems,
    this.totalPages,
  });

  factory PaginatedDailyMoodAssessmentsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedDailyMoodAssessmentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedDailyMoodAssessmentsModelToJson(this);
}
