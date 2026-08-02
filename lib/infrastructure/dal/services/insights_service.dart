import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/assessment/mood_tracker_stats.model.dart';
import '../../../../data/model/assessment/growth_areas_response.model.dart';

class InsightsService {
  InsightsService._();

  static final ApiClient client = ApiClient();

  /// Retrieve Mood Tracker Calendar statistics
  static Future<ApiResponse<MoodTrackerStatsModel>?> getMoodTrackerStats({
    String? fromDate,
    String? toDate,
    String? timezone,
  }) async {
    return client.request<ApiResponse<MoodTrackerStatsModel>>(
      (dio) => dio.get(
        'insights/mood-tracker',
        queryParameters: {
          if (fromDate != null) 'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          if (timezone != null) 'timezone': timezone,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<MoodTrackerStatsModel>.fromJson(
          json as Map<String, dynamic>,
          (data) =>
              MoodTrackerStatsModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Retrieve Growth Areas Progress
  static Future<ApiResponse<GrowthAreasResponseModel>?> getGrowthAreas({
    String? fromDate,
    String? toDate,
    String timezone = "UTC",
  }) async {
    return client.request<ApiResponse<GrowthAreasResponseModel>>(
      (dio) => dio.get(
        'insights/growth-areas',
        queryParameters: {
          if (fromDate != null) 'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          'timezone': timezone,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<GrowthAreasResponseModel>.fromJson(
          json as Map<String, dynamic>,
          (data) =>
              GrowthAreasResponseModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
