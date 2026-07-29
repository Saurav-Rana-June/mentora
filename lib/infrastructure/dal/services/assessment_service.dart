import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/assessment/daily_mood_assessment.model.dart';

class AssessmentService {
  AssessmentService._();

  static final ApiClient client = ApiClient();

  /// Create or update today's mood check-in
  static Future<ApiResponse<DailyMoodAssessmentModel>?> createOrUpdateDailyMood({
    required String feeling,
    List<String>? why,
    List<String>? exactFeeling,
    String? notes,
    String timezone = "UTC",
  }) async {
    return client.request<ApiResponse<DailyMoodAssessmentModel>>(
      (dio) => dio.post(
        'assessment/mood',
        queryParameters: {
          'timezone': timezone,
        },
        data: {
          'feeling': feeling,
          if (why != null) 'why': why,
          if (exactFeeling != null) 'exactFeeling': exactFeeling,
          if (notes != null) 'notes': notes,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<DailyMoodAssessmentModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => DailyMoodAssessmentModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
