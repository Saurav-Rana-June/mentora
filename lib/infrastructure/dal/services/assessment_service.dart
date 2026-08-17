import '../../../../data/enums/date_filter_enum.dart';
import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/daily_mood_assessment.model.dart';
import '../../../../data/model/paginated_daily_mood_assessments.model.dart';
import '../../../../data/model/streak_stats.model.dart';

class AssessmentService {
  AssessmentService._();

  static final ApiClient client = ApiClient();

  /// Create onboarding wellness assessment responses
  static Future<ApiResponse<dynamic>?> createAssessment({
    required List<String> mainGoals,
    required List<String> healthIssues,
    String? pastYearStressFrequency,
    String? eatHealthy,
    String? triedMeditation,
    String? sleepQuality,
    String? happinessLevel,
  }) async {
    return client.request<ApiResponse<dynamic>>(
      (dio) => dio.post(
        'assessment/create',
        data: {
          'mainGoals': mainGoals,
          'healthIssues': healthIssues,
          if (pastYearStressFrequency != null) 'pastYearStressFrequency': pastYearStressFrequency,
          if (eatHealthy != null) 'eatHealthy': eatHealthy,
          if (triedMeditation != null) 'triedMeditation': triedMeditation,
          if (sleepQuality != null) 'sleepQuality': sleepQuality,
          if (happinessLevel != null) 'happinessLevel': happinessLevel,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<dynamic>.fromJson(
          json as Map<String, dynamic>,
          (data) => data,
        );
      },
    );
  }

  /// Update user wellness assessment details
  static Future<ApiResponse<dynamic>?> updateAssessment({
    List<String>? mainGoals,
    List<String>? healthIssues,
    String? pastYearStressFrequency,
    String? eatHealthy,
    String? triedMeditation,
    String? sleepQuality,
    String? happinessLevel,
  }) async {
    return client.request<ApiResponse<dynamic>>(
      (dio) => dio.put(
        'assessment/update',
        data: {
          if (mainGoals != null) 'mainGoals': mainGoals,
          if (healthIssues != null) 'healthIssues': healthIssues,
          if (pastYearStressFrequency != null) 'pastYearStressFrequency': pastYearStressFrequency,
          if (eatHealthy != null) 'eatHealthy': eatHealthy,
          if (triedMeditation != null) 'triedMeditation': triedMeditation,
          if (sleepQuality != null) 'sleepQuality': sleepQuality,
          if (happinessLevel != null) 'happinessLevel': happinessLevel,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<dynamic>.fromJson(
          json as Map<String, dynamic>,
          (data) => data,
        );
      },
    );
  }

  /// Retrieve onboarding wellness assessment details
  static Future<ApiResponse<dynamic>?> getAssessment({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<dynamic>>(
      (dio) => dio.get(
        'assessment/me',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<dynamic>.fromJson(
          json as Map<String, dynamic>,
          (data) => data,
        );
      },
    );
  }

  /// Create or update today's mood check-in
  static Future<ApiResponse<DailyMoodAssessmentModel>?>
  createOrUpdateDailyMood({
    required String feeling,
    List<String>? why,
    List<String>? exactFeeling,
    String? notes,
    String timezone = "UTC",
  }) async {
    return client.request<ApiResponse<DailyMoodAssessmentModel>>(
      (dio) => dio.post(
        'assessment/mood',
        queryParameters: {'timezone': timezone},
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
          (data) =>
              DailyMoodAssessmentModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Get user check-in streak stats
  static Future<ApiResponse<StreakStatsModel>?> getStreakStats({
    String? lastUpdated,
  }) async {
    return client.request<ApiResponse<StreakStatsModel>>(
      (dio) => dio.get(
        'assessment/streak',
        queryParameters: {
          if (lastUpdated != null) 'lastUpdated': lastUpdated,
        },
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

  /// Retrieve all user daily mood check-ins (non-paginated)
  static Future<ApiResponse<List<DailyMoodAssessmentModel>>?> getDailyMoods({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<DailyMoodAssessmentModel>>>(
      (dio) => dio.get(
        'assessment/moods',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<DailyMoodAssessmentModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => DailyMoodAssessmentModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Get daily check-in history (paginated)
  static Future<ApiResponse<PaginatedDailyMoodAssessmentsModel>?>
  getDailyMoodsHistory({
    int page = 1,
    int size = 10,
    String sortType = "desc",
    DateFilter? dateFilter,
    String? lastUpdated,
  }) async {
    return client.request<ApiResponse<PaginatedDailyMoodAssessmentsModel>>(
      (dio) => dio.get(
        'assessment/moods/paginated',
        queryParameters: {
          'page': page,
          'size': size,
          'sortType': sortType,
          if (dateFilter != null) 'dateFilter': dateFilter.value,
          if (lastUpdated != null) 'lastUpdated': lastUpdated,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<PaginatedDailyMoodAssessmentsModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => PaginatedDailyMoodAssessmentsModel.fromJson(
            data as Map<String, dynamic>,
          ),
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
    return client.request<ApiResponse<DailyMoodAssessmentModel>>(
      (dio) => dio.put(
        'assessment/mood',
        queryParameters: {'timezone': timezone},
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
          (data) =>
              DailyMoodAssessmentModel.fromJson(data as Map<String, dynamic>),
        );
        return parsed;
      },
    );
  }
}
