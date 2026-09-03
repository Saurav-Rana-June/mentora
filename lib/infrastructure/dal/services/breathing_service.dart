import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/breathing_pattern.model.dart';

class BreathingService {
  BreathingService._();

  static final ApiClient client = ApiClient();

  /// Retrieve all breathing patterns from the backend with optional search filter
  static Future<ApiResponse<List<BreathingPatternModel>>?>
  getBreathingPatterns({String? search, String? lastUpdated}) async {
    final Map<String, dynamic> params = {};
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<BreathingPatternModel>>>(
      (dio) => dio.get('breathing', queryParameters: params),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<BreathingPatternModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map(
                  (e) =>
                      BreathingPatternModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve details of a single breathing technique by ID
  static Future<ApiResponse<BreathingPatternModel>?>
  getBreathingPatternDetails({
    required int breathingId,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<BreathingPatternModel>>(
      (dio) => dio.get('breathing/$breathingId', queryParameters: params),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<BreathingPatternModel>.fromJson(
          json as Map<String, dynamic>,
          (data) =>
              BreathingPatternModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
