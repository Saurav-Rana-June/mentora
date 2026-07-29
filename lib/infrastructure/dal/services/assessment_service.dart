import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/assessment/daily_mood_assessment.model.dart';
import '../../../../data/model/assessment/streak_stats.model.dart';

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

  /// Get user check-in streak stats
  static Future<ApiResponse<StreakStatsModel>?> getStreakStats() async {
    return client.request<ApiResponse<StreakStatsModel>>(
      (dio) => dio.get(
        'assessment/streak',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<StreakStatsModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => StreakStatsModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Get daily check-in history
  static Future<ApiResponse<List<DailyMoodAssessmentModel>>?> getDailyMoods() async {
    return client.request<ApiResponse<List<DailyMoodAssessmentModel>>>(
      (dio) => dio.get(
        'assessment/moods',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<DailyMoodAssessmentModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>;
            return list
                .map((e) => DailyMoodAssessmentModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Update today's mood check-in
  static Future<ApiResponse<DailyMoodAssessmentModel>?> updateDailyMood({
    required String feeling,
    List<String>? why,
    List<String>? exactFeeling,
    String? notes,
    String timezone = "UTC",
  }) async {
    return client.request<ApiResponse<DailyMoodAssessmentModel>> (
      (dio) => dio.put(
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
        final parsed = ApiResponse<DailyMoodAssessmentModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => DailyMoodAssessmentModel.fromJson(data as Map<String, dynamic>),
        );
        return parsed;
      },
    );
  }
}
