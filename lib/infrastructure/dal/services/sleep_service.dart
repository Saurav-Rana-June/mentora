import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../presentation/sleep/controllers/sleep.controller.dart';

class SleepService {
  SleepService._();

  static final ApiClient client = ApiClient();

  /// Retrieve all sleep sounds based on optional category and lastUpdated filters
  static Future<ApiResponse<List<Sound>>?> getSleepSounds({
    String? category,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<Sound>>>(
      (dio) => dio.get(
        'sleep/sounds',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<Sound>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => Sound.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve all sleep music tracks based on optional category and lastUpdated filters
  static Future<ApiResponse<List<CalmMusic>>?> getSleepMusic({
    String? category,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<CalmMusic>>>(
      (dio) => dio.get(
        'sleep/music',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<CalmMusic>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => CalmMusic.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve all sleep bedtime stories based on optional category and lastUpdated filters
  static Future<ApiResponse<List<Story>>?> getSleepStories({
    String? category,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<Story>>>(
      (dio) => dio.get(
        'sleep/stories',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<Story>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => Story.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }
}
