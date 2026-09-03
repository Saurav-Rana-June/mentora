import 'dart:async';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import '../../../infrastructure/dal/services/sleep_service.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/story.model.dart';

class SleepController extends GetxController {
  final selectedTabIndex = 0.obs;

  final tabs = ["Sounds", "Music", "Stories"];

  RxInt selectedIndexCategory = 0.obs;

  RxInt selectedSoundIndex = (-1).obs;

  // Active list buffers
  final RxList<String> categories = <String>[
    'All',
    'Popular',
    'Nature',
    'Traffic',
    'Animals',
    'Household',
    'Music',
  ].obs;

  final RxList<SoundModel> sounds = <SoundModel>[].obs;
  final RxList<CalmMusicModel> calmMusics = <CalmMusicModel>[].obs;
  final RxList<StoryModel> stories = <StoryModel>[].obs;

  final RxBool isLoading = true.obs;

  // Cache keys
  static const String soundsCacheKey = StorageKeys.SLEEP_SOUNDS;
  static const String soundsLastUpdatedKey = StorageKeys.SLEEP_SOUNDS_LAST_UPDATED;

  static const String musicCacheKey = StorageKeys.SLEEP_MUSIC;
  static const String musicLastUpdatedKey = StorageKeys.SLEEP_MUSIC_LAST_UPDATED;

  static const String storiesCacheKey = StorageKeys.SLEEP_STORIES;
  static const String storiesLastUpdatedKey = StorageKeys.SLEEP_STORIES_LAST_UPDATED;

  @override
  void onInit() {
    super.onInit();
    fetchSleepData();
  }

  /// Fetch all sleep data (sounds, music, stories) in parallel
  Future<void> fetchSleepData({bool forceRefresh = false}) async {
    final hasSoundsCache =
        StorageUtils.read<List<dynamic>>(soundsCacheKey) != null &&
        StorageUtils.read<String>(soundsLastUpdatedKey) != null;
    final hasMusicCache =
        StorageUtils.read<List<dynamic>>(musicCacheKey) != null &&
        StorageUtils.read<String>(musicLastUpdatedKey) != null;
    final hasStoriesCache =
        StorageUtils.read<List<dynamic>>(storiesCacheKey) != null &&
        StorageUtils.read<String>(storiesLastUpdatedKey) != null;

    final hasAllCache = hasSoundsCache && hasMusicCache && hasStoriesCache;

    if (!hasAllCache && !forceRefresh) {
      isLoading.value = true;
    } else {
      isLoading.value = false;
    }

    await Future.wait([
      fetchSounds(forceRefresh: forceRefresh),
      fetchMusic(forceRefresh: forceRefresh),
      fetchStories(forceRefresh: forceRefresh),
    ]);
    isLoading.value = false;
  }

  /// Fetch Sleep Sounds (with local caching & lastUpdated checks)
  Future<void> fetchSounds({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await StorageUtils.remove(soundsCacheKey);
      await StorageUtils.remove(soundsLastUpdatedKey);
    }
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(
        soundsCacheKey,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        soundsLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        sounds.assignAll(
          cachedData
              .map((e) => SoundModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
        );
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepSounds(
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(
            cachedLastUpdated!,
          );
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepSounds();
      if (res != null && res.data != null) {
        sounds.assignAll(res.data!);
        await StorageUtils.write(
          soundsCacheKey,
          res.data!.map((e) => e.toJson()).toList(),
        );
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            soundsLastUpdatedKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep sounds: $e");
    }
  }

  /// Fetch Sleep Music (with local caching & lastUpdated checks)
  Future<void> fetchMusic({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await StorageUtils.remove(musicCacheKey);
      await StorageUtils.remove(musicLastUpdatedKey);
    }
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(
        musicCacheKey,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        musicLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        calmMusics.assignAll(
          cachedData
              .map(
                (e) => CalmMusicModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList(),
        );
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepMusic(
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(
            cachedLastUpdated!,
          );
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepMusic();
      if (res != null && res.data != null) {
        calmMusics.assignAll(res.data!);
        await StorageUtils.write(
          musicCacheKey,
          res.data!.map((e) => e.toJson()).toList(),
        );
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            musicLastUpdatedKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep music: $e");
    }
  }

  /// Fetch Sleep Stories (with local caching & lastUpdated checks)
  Future<void> fetchStories({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await StorageUtils.remove(storiesCacheKey);
      await StorageUtils.remove(storiesLastUpdatedKey);
    }
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(
        storiesCacheKey,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        storiesLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        stories.assignAll(
          cachedData
              .map((e) => StoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
        );
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepStories(
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(
            cachedLastUpdated!,
          );
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepStories();
      if (res != null && res.data != null) {
        stories.assignAll(res.data!);
        await StorageUtils.write(
          storiesCacheKey,
          res.data!.map((e) => e.toJson()).toList(),
        );
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            storiesLastUpdatedKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep stories: $e");
    }
  }
}
