import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import 'package:Mentora/data/model/video_session.model.dart';

class VideoSessionService {
  VideoSessionService._();

  static final ApiClient client = ApiClient();

  /// Retrieve distinct categories (filters) for video sessions
  static Future<ApiResponse<List<String>>?> getVideoSessionFilters({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<String>>>(
      (dio) => dio.get(
        'videoSession/filters',
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

  /// Retrieve all video sessions based on optional category and search query filters
  static Future<ApiResponse<List<VideoSessionModel>>?> getVideoSessions({
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

    return client.request<ApiResponse<List<VideoSessionModel>>>(
      (dio) => dio.get(
        'video_session',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<VideoSessionModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => VideoSessionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve details of a single video session by ID
  static Future<ApiResponse<VideoSessionModel>?> getVideoSessionDetails({
    required int videoSessionId,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<VideoSessionModel>>(
      (dio) => dio.get(
        'video_session/$videoSessionId',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<VideoSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => VideoSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  // ---------------- ADMIN CMS ENDPOINTS ---------------- //

  /// Create a new video session (Admin CMS)
  static Future<ApiResponse<VideoSessionModel>?> createVideoSession(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<VideoSessionModel>>(
      (dio) => dio.post(
        'admin/video_session',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<VideoSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => VideoSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update an existing video session (Admin CMS)
  static Future<ApiResponse<VideoSessionModel>?> updateVideoSession(
    int videoSessionId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<VideoSessionModel>>(
      (dio) => dio.put(
        'admin/video_session/$videoSessionId',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<VideoSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => VideoSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a video session (Admin CMS)
  static Future<ApiResponse<VideoSessionModel>?> deleteVideoSession(
    int videoSessionId,
  ) async {
    return client.request<ApiResponse<VideoSessionModel>>(
      (dio) => dio.delete(
        'admin/video_session/$videoSessionId',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<VideoSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => VideoSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
