import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/assessment/mood_tracker_stats.model.dart';

class InsightsService {
  InsightsService._();

  static final ApiClient client = ApiClient();

  /// Retrieve Mood Tracker Calendar statistics
  static Future<ApiResponse<MoodTrackerStatsModel>?> getMoodTrackerStats({
    String? range,
    String? timezone,
  }) async {
    return client.request<ApiResponse<MoodTrackerStatsModel>>(
      (dio) => dio.get(
        'insights/mood-tracker',
        queryParameters: {
          if (range != null) 'range': range,
          if (timezone != null) 'timezone': timezone,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<MoodTrackerStatsModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => MoodTrackerStatsModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
