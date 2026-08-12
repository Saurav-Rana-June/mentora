import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/story.model.dart';

class SleepService {
  SleepService._();

  static final ApiClient client = ApiClient();

  /// Retrieve all sleep sounds based on optional category and lastUpdated filters
  static Future<ApiResponse<List<SoundModel>>?> getSleepSounds({
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

    return client.request<ApiResponse<List<SoundModel>>>(
      (dio) => dio.get(
        'sleep/sounds',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<SoundModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => SoundModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve all sleep music tracks based on optional category and lastUpdated filters
  static Future<ApiResponse<List<CalmMusicModel>>?> getSleepMusic({
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

    return client.request<ApiResponse<List<CalmMusicModel>>>(
      (dio) => dio.get(
        'sleep/music',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<CalmMusicModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => CalmMusicModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve all sleep bedtime stories based on optional category and lastUpdated filters
  static Future<ApiResponse<List<StoryModel>>?> getSleepStories({
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

    return client.request<ApiResponse<List<StoryModel>>>(
      (dio) => dio.get(
        'sleep/stories',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<StoryModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }
}
