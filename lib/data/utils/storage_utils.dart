import 'package:get_storage/get_storage.dart';

class StorageUtils {
  StorageUtils._();

  static final GetStorage _box = GetStorage();

  /// Reads a value of type [T] from local storage.
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Writes [value] to local storage.
  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Removes a value from local storage.
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }
}

class StorageKeys {
  StorageKeys._();

  // Meditation Keys
  static const String MEDITATION_CATEGORIES = 'meditation_categories_filters';
  static const String MEDITATION_CATEGORIES_LAST_UPDATED =
      'meditation_categories_last_updated';
  static String meditationAll(String category, String query) =>
      'meditations_all_${category}_${query}';
  static String meditationAllLastUpdated(String category, String query) =>
      'meditations_all_last_updated_${category}_${query}';

  // Featured Meditations Keys
  static const String FEATURED_MEDITATIONS = 'global_featured_meditations';
  static const String FEATURED_MEDITATIONS_LAST_UPDATED =
      'global_featured_meditations_last_updated';

  // Sleep Keys
  static const String SLEEP_SOUNDS = 'sleep_sounds_cache_data';
  static const String SLEEP_SOUNDS_LAST_UPDATED =
      'sleep_sounds_cache_last_updated';
  static const String SLEEP_MUSIC = 'sleep_music_cache_data';
  static const String SLEEP_MUSIC_LAST_UPDATED =
      'sleep_music_cache_last_updated';
  static const String SLEEP_STORIES = 'sleep_stories_cache_data';
  static const String SLEEP_STORIES_LAST_UPDATED =
      'sleep_stories_cache_last_updated';

  // Journaling Keys
  static const String JOURNALING_QUESTIONS = 'journaling_questions_cache';
  static const String JOURNALING_QUESTIONS_LAST_UPDATED =
      'journaling_questions_last_updated';
  static const String JOURNALING_ENTRIES = 'journaling_entries_cache';
  static const String JOURNALING_ENTRIES_LAST_UPDATED =
      'journaling_entries_last_updated';

  // Insights Keys
  static const String COACHING_BANNER = 'insights_coaching_banner_data';
  static const String COACHING_BANNER_LAST_UPDATED =
      'insights_coaching_banner_last_updated';
  static String growthAreas(String filterName) =>
      'insights_growth_areas_$filterName';
  static String growthAreasLastUpdated(String filterName) =>
      'insights_growth_areas_last_updated_$filterName';

  // Home Keys
  static const String STREAK_STATS = 'home_streak_stats_data';
  static const String STREAK_STATS_LAST_UPDATED =
      'home_streak_stats_last_updated';
  static const String DAILY_PLAN = 'home_daily_plan_data';

  // Breathing Keys
  static const String BREATHING_PATTERNS = 'breathing_techniques_patterns';
  static const String BREATHING_PATTERNS_LAST_UPDATED =
      'breathing_techniques_last_updated';

  // Global Keys
  static String globalMoodHistory(String filterName) =>
      'global_mood_history_$filterName';
  static String globalMoodHistoryLastUpdated(String filterName) =>
      'global_mood_history_last_updated_$filterName';
  static String insightsMoodTracker(String suffix) =>
      'insights_mood_tracker_$suffix';
  static String insightsMoodTrackerLastUpdated(String suffix) =>
      'insights_mood_tracker_last_updated_$suffix';

  // Video Session Keys
  static const String VIDEO_SESSION_CATEGORIES = 'video_session_categories_filters';
  static const String VIDEO_SESSION_CATEGORIES_LAST_UPDATED =
      'video_session_categories_last_updated';
  static String videoSessionAll(String category, String query) =>
      'video_sessions_all_${category}_${query}';
  static String videoSessionAllLastUpdated(String category, String query) =>
      'video_sessions_all_last_updated_${category}_${query}';

  // Doctor Keys
  static const String DOCTORS = 'doctors_cache';
  static const String DOCTORS_LAST_UPDATED = 'doctors_last_updated';
  static const String DOCTORS_TOTAL_PAGES = 'doctors_total_pages';

  // Booking Session Keys
  static String doctorAvailability(int doctorId, String date) =>
      'booking_avail_${doctorId}_$date';
  static String doctorAvailabilityLastUpdated(int doctorId, String date) =>
      'booking_avail_last_updated_${doctorId}_$date';
  static String sessionInfo(int doctorId) => 'booking_info_$doctorId';
  static String sessionInfoLastUpdated(int doctorId) => 'booking_info_last_updated_$doctorId';
  static const String MY_SESSIONS = 'my_sessions_cache';
  static const String MY_SESSIONS_LAST_UPDATED = 'my_sessions_last_updated';
}
