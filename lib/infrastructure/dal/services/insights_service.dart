import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/mood_tracker_stats.model.dart';
import '../../../../data/model/growth_areas_response.model.dart';
import '../../../../data/model/coaching_banner_response.model.dart';

class InsightsService {
  InsightsService._();

  static final ApiClient client = ApiClient();

  /// Retrieve Coaching Banner recommendation
  static Future<ApiResponse<CoachingBannerResponseModel>?> getCoachingBanner({
    String timezone = "UTC",
    String? lastUpdated,
  }) async {
    return client.request<ApiResponse<CoachingBannerResponseModel>>(
      (dio) => dio.get(
        'insights/coaching-banner',
        queryParameters: {
          'timezone': timezone,
          if (lastUpdated != null) 'lastUpdated': lastUpdated,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<CoachingBannerResponseModel>.fromJson(
          json as Map<String, dynamic>,
          (data) =>
              CoachingBannerResponseModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Retrieve Mood Tracker Calendar statistics
  static Future<ApiResponse<MoodTrackerStatsModel>?> getMoodTrackerStats({
    String? fromDate,
    String? toDate,
    String? dateFilter,
    String? timezone,
    String? lastUpdated,
  }) async {
    return client.request<ApiResponse<MoodTrackerStatsModel>>(
      (dio) => dio.get(
        'insights/mood-tracker',
        queryParameters: {
          if (fromDate != null) 'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          if (dateFilter != null) 'dateFilter': dateFilter,
          if (timezone != null) 'timezone': timezone,
          if (lastUpdated != null) 'lastUpdated': lastUpdated,
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
    String? dateFilter,
    String timezone = "UTC",
    String? lastUpdated,
  }) async {
    return client.request<ApiResponse<GrowthAreasResponseModel>>(
      (dio) => dio.get(
        'insights/growth-areas',
        queryParameters: {
          if (fromDate != null) 'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          if (dateFilter != null) 'dateFilter': dateFilter,
          'timezone': timezone,
          if (lastUpdated != null) 'lastUpdated': lastUpdated,
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
