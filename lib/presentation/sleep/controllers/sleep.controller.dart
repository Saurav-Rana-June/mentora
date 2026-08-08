import 'dart:async';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import '../../../infrastructure/dal/services/sleep_service.dart';

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

  final RxList<Sound> sounds = <Sound>[].obs;
  final RxList<CalmMusic> calmMusics = <CalmMusic>[].obs;
  final RxList<Story> stories = <Story>[].obs;

  final RxBool isLoading = true.obs;

  // Cache keys
  static const String _soundsCacheKey = 'sleep_sounds_cache_data';
  static const String _soundsLastUpdatedKey = 'sleep_sounds_cache_last_updated';

  static const String _musicCacheKey = 'sleep_music_cache_data';
  static const String _musicLastUpdatedKey = 'sleep_music_cache_last_updated';

  static const String _storiesCacheKey = 'sleep_stories_cache_data';
  static const String _storiesLastUpdatedKey = 'sleep_stories_cache_last_updated';

  @override
  void onInit() {
    super.onInit();
    fetchSleepData();
  }

  /// Fetch all sleep data (sounds, music, stories) in parallel
  Future<void> fetchSleepData({bool forceRefresh = false}) async {
    isLoading.value = true;
    await Future.wait([
      fetchSounds(forceRefresh: forceRefresh),
      fetchMusic(forceRefresh: forceRefresh),
      fetchStories(forceRefresh: forceRefresh),
    ]);
    isLoading.value = false;
  }

  /// Fetch Sleep Sounds (with local caching & lastUpdated checks)
  Future<void> fetchSounds({bool forceRefresh = false}) async {
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(_soundsCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_soundsLastUpdatedKey);

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        sounds.assignAll(cachedData.map((e) => Sound.fromJson(Map<String, dynamic>.from(e as Map))).toList());
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepSounds(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepSounds();
      if (res != null && res.data != null) {
        sounds.assignAll(res.data!);
        await StorageUtils.write(_soundsCacheKey, res.data!.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(_soundsLastUpdatedKey, res.lastUpdated!.toIso8601String());
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep sounds: $e");
    }
  }

  /// Fetch Sleep Music (with local caching & lastUpdated checks)
  Future<void> fetchMusic({bool forceRefresh = false}) async {
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(_musicCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_musicLastUpdatedKey);

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        calmMusics.assignAll(cachedData.map((e) => CalmMusic.fromJson(Map<String, dynamic>.from(e as Map))).toList());
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepMusic(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepMusic();
      if (res != null && res.data != null) {
        calmMusics.assignAll(res.data!);
        await StorageUtils.write(_musicCacheKey, res.data!.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(_musicLastUpdatedKey, res.lastUpdated!.toIso8601String());
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep music: $e");
    }
  }

  /// Fetch Sleep Stories (with local caching & lastUpdated checks)
  Future<void> fetchStories({bool forceRefresh = false}) async {
    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(_storiesCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_storiesLastUpdatedKey);

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        stories.assignAll(cachedData.map((e) => Story.fromJson(Map<String, dynamic>.from(e as Map))).toList());
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await SleepService.getSleepStories(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date
            return;
          }
        }
      }

      final res = await SleepService.getSleepStories();
      if (res != null && res.data != null) {
        stories.assignAll(res.data!);
        await StorageUtils.write(_storiesCacheKey, res.data!.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(_storiesLastUpdatedKey, res.lastUpdated!.toIso8601String());
        }
      }
    } catch (e) {
      Get.log("Failed to load sleep stories: $e");
    }
  }
}

class Sound {
  final int id;
  final String emoji;
  final String title;
  final String audioUrl;
  final String category;

  Sound({
    required this.id,
    required this.emoji,
    required this.title,
    required this.audioUrl,
    required this.category,
  });

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      id: json['id'] as int,
      emoji: json['emoji'] as String,
      title: json['title'] as String,
      audioUrl: json['audioUrl'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'title': title,
        'audioUrl': audioUrl,
        'category': category,
      };
}

class CalmMusic {
  final int id;
  final String title;
  final String duration;
  final String imageUrl;
  final String audioUrl;
  final String category;
  final String description;

  CalmMusic({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.audioUrl,
    required this.category,
    required this.description,
  });

  factory CalmMusic.fromJson(Map<String, dynamic> json) {
    return CalmMusic(
      id: json['id'] as int,
      title: json['title'] as String,
      duration: json['duration'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'category': category,
        'description': description,
      };
}

class Story {
  final int id;
  final String title;
  final String duration;
  final String imageUrl;
  final String audioUrl;
  final String category;
  final String description;

  const Story({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.audioUrl,
    required this.category,
    required this.description,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int,
      title: json['title'] as String,
      duration: json['duration'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'category': category,
        'description': description,
      };
}
