import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import 'package:Mentora/data/model/meditation_session.model.dart';

class MeditationService {
  MeditationService._();

  static final ApiClient client = ApiClient();

  /// Retrieve distinct categories (filters) for meditations
  static Future<ApiResponse<List<String>>?> getMeditationFilters({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<String>>>(
      (dio) => dio.get(
        'meditations/filters',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<String>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list.map((e) => e.toString()).toList();
          },
        );
      },
    );
  }

  /// Retrieve all meditations based on optional category and search query filters
  static Future<ApiResponse<List<MeditationSessionModel>>?> getMeditations({
    String? category,
    String? search,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<MeditationSessionModel>>>(
      (dio) => dio.get(
        'meditations',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<MeditationSessionModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => MeditationSessionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve featured meditations based on optional category and search query filters
  static Future<ApiResponse<List<MeditationSessionModel>>?> getFeaturedMeditations({
    String? category,
    String? search,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<MeditationSessionModel>>>(
      (dio) => dio.get(
        'meditations/featured',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<MeditationSessionModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => MeditationSessionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve details for a single meditation by its ID
  static Future<ApiResponse<MeditationSessionModel>?> getMeditationDetails({
    required int meditationId,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<MeditationSessionModel>>(
      (dio) => dio.get(
        'meditations/$meditationId',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<MeditationSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => MeditationSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
