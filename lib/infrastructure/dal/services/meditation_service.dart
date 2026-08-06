import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../presentation/meditation/widgets/meditation_session.dart';

class MeditationService {
  MeditationService._();

  static final ApiClient client = ApiClient();

  /// Retrieve distinct categories (filters) for meditations
  static Future<ApiResponse<List<String>>?> getMeditationFilters() async {
    return client.request<ApiResponse<List<String>>>(
      (dio) => dio.get('meditations/filters'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<String>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>;
            return list.map((e) => e.toString()).toList();
          },
        );
      },
    );
  }

  /// Retrieve all meditations based on optional category and search query filters
  static Future<ApiResponse<List<MeditationSession>>?> getMeditations({
    String? category,
    String? search,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    return client.request<ApiResponse<List<MeditationSession>>>(
      (dio) => dio.get(
        'meditations',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<MeditationSession>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>;
            return list
                .map((e) => MeditationSession.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve featured meditations based on optional category and search query filters
  static Future<ApiResponse<List<MeditationSession>>?> getFeaturedMeditations({
    String? category,
    String? search,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category != 'All') {
      params['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    return client.request<ApiResponse<List<MeditationSession>>>(
      (dio) => dio.get(
        'meditations/featured',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<MeditationSession>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>;
            return list
                .map((e) => MeditationSession.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }
}
