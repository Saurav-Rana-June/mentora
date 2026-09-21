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

  // ---------------- ADMIN CMS ENDPOINTS: SLEEP SOUNDS ---------------- //

  /// Create a new sleep sound (Admin CMS)
  static Future<ApiResponse<SoundModel>?> createSleepSound(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<SoundModel>>(
      (dio) => dio.post(
        'admin/sleep/sounds',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<SoundModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => SoundModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update a sleep sound (Admin CMS)
  static Future<ApiResponse<SoundModel>?> updateSleepSound(
    int soundId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<SoundModel>>(
      (dio) => dio.put(
        'admin/sleep/sounds/$soundId',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<SoundModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => SoundModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a sleep sound (Admin CMS)
  static Future<ApiResponse<SoundModel>?> deleteSleepSound(
    int soundId,
  ) async {
    return client.request<ApiResponse<SoundModel>>(
      (dio) => dio.delete(
        'admin/sleep/sounds/$soundId',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<SoundModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => SoundModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  // ---------------- ADMIN CMS ENDPOINTS: SLEEP MUSIC ---------------- //

  /// Create a new sleep music track (Admin CMS)
  static Future<ApiResponse<CalmMusicModel>?> createSleepMusic(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<CalmMusicModel>>(
      (dio) => dio.post(
        'admin/sleep/music',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<CalmMusicModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => CalmMusicModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update a sleep music track (Admin CMS)
  static Future<ApiResponse<CalmMusicModel>?> updateSleepMusic(
    int musicId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<CalmMusicModel>>(
      (dio) => dio.put(
        'admin/sleep/music/$musicId',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<CalmMusicModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => CalmMusicModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a sleep music track (Admin CMS)
  static Future<ApiResponse<CalmMusicModel>?> deleteSleepMusic(
    int musicId,
  ) async {
    return client.request<ApiResponse<CalmMusicModel>>(
      (dio) => dio.delete(
        'admin/sleep/music/$musicId',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<CalmMusicModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => CalmMusicModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  // ---------------- ADMIN CMS ENDPOINTS: SLEEP STORIES ---------------- //

  /// Create a new bedtime story (Admin CMS)
  static Future<ApiResponse<StoryModel>?> createSleepStory(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<StoryModel>>(
      (dio) => dio.post(
        'admin/sleep/stories',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<StoryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => StoryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update a bedtime story (Admin CMS)
  static Future<ApiResponse<StoryModel>?> updateSleepStory(
    int storyId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<StoryModel>>(
      (dio) => dio.put(
        'admin/sleep/stories/$storyId',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<StoryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => StoryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a bedtime story (Admin CMS)
  static Future<ApiResponse<StoryModel>?> deleteSleepStory(
    int storyId,
  ) async {
    return client.request<ApiResponse<StoryModel>>(
      (dio) => dio.delete(
        'admin/sleep/stories/$storyId',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<StoryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => StoryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
