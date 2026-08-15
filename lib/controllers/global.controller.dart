import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/daily_mood_assessment.model.dart';
import 'package:Mentora/data/model/paginated_daily_mood_assessments.model.dart';
import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';
import 'package:Mentora/data/model/mood_tracker_stats.model.dart';
import 'package:Mentora/data/model/profile.model.dart';
import 'package:Mentora/infrastructure/dal/services/profile_service.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/data/model/meditation_session.model.dart';
import 'package:Mentora/infrastructure/dal/services/meditation_service.dart';

class GlobalController extends GetxController {
  final Rx<DateFilter> selectedDateFilter = DateFilter.allTime.obs;
  bool _isFetchingHistory = false;
  final RxBool isLoadingMoodTracker = false.obs;
  final Rxn<MoodTrackerStatsModel> moodTrackerStats =
      Rxn<MoodTrackerStatsModel>();
  final Rxn<MoodTrackerStatsModel> moodTrackerStatsThisWeek =
      Rxn<MoodTrackerStatsModel>();

  final RxList<DailyMoodAssessmentModel> moodHistoryList =
      <DailyMoodAssessmentModel>[].obs;

  final Rx<DailyMoodAssessmentModel?> todayCheckIn =
      Rx<DailyMoodAssessmentModel?>(null);

  // Check-in history
  final RxList<DateTime> checkInDates = <DateTime>[].obs;
  final RxList<String> checkInMoods = <String>[].obs;

  final Rxn<ProfileModel> userProfile = Rxn<ProfileModel>();
  final RxBool isLoadingProfile = false.obs;
  final RxString latestMood = ''.obs;

  // Featured Meditations
  final featuredMeditations = <MeditationSessionModel>[].obs;
  final RxBool isLoadingFeaturedMeditations = false.obs;

  static const String _featuredMeditationsCacheKey =
      'global_featured_meditations';
  static const String _featuredMeditationsLastUpdatedKey =
      'global_featured_meditations_last_updated';

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();

    Future.wait([
      fetchMoodHistory(),
      fetchMoodTrackerStats(),
      fetchFeaturedMeditations(),
    ]);
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;
      final response = await ProfileService.getProfile();
      if (response != null && response.data != null) {
        userProfile.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching user profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchMoodHistory({bool forceRefresh = false}) async {
    final String moodHistoryCacheKey =
        'global_mood_history_${selectedDateFilter.value.name}';
    final String moodHistoryLastUpdatedKey =
        'global_mood_history_last_updated_${selectedDateFilter.value.name}';

    try {
      // 1. Try to load check-ins from cache first
      final cachedHistory = StorageUtils.read<Map<String, dynamic>>(
        moodHistoryCacheKey,
      );
      final cachedLastUpdated = StorageUtils.read<String>(
        moodHistoryLastUpdatedKey,
      );

      bool hasCache = cachedHistory != null && cachedLastUpdated != null;
      if (hasCache) {
        final paginatedModel = PaginatedDailyMoodAssessmentsModel.fromJson(
          cachedHistory,
        );
        final List<DailyMoodAssessmentModel> history =
            paginatedModel.items ?? [];
        moodHistoryList.assignAll(history);

        checkInDates.clear();
        checkInMoods.clear();

        final today = DateTime.now();
        DailyMoodAssessmentModel? foundToday;

        for (var checkIn in history) {
          final DateTime? checkInDate = checkIn.createdAt != null
              ? DateTime.tryParse(checkIn.createdAt!)?.toLocal()
              : null;
          if (checkInDate != null) {
            checkInDates.add(checkInDate);
            checkInMoods.add(checkIn.feeling ?? '');

            if (checkInDate.year == today.year &&
                checkInDate.month == today.month &&
                checkInDate.day == today.day) {
              foundToday = checkIn;
            }
          }
        }

        todayCheckIn.value = foundToday;
        if (foundToday != null) {
          latestMood.value = foundToday.feeling ?? '';
        }
      }

      // 2. Perform lightweight timestamp verification check if not force-refreshing
      if (hasCache && !forceRefresh) {
        final checkRes = await AssessmentService.getDailyMoodsHistory(
          page: 1,
          size: 50,
          dateFilter: selectedDateFilter.value,
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated);
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date! Stop here.
            return;
          }
        }
      }

      // 3. Fetch fresh history
      final response = await AssessmentService.getDailyMoodsHistory(
        page: 1,
        size: 50,
        dateFilter: selectedDateFilter.value,
      );
      if (response != null && response.data != null) {
        final List<DailyMoodAssessmentModel> history =
            response.data!.items ?? [];

        moodHistoryList.assignAll(history);

        checkInDates.clear();
        checkInMoods.clear();

        final today = DateTime.now();
        DailyMoodAssessmentModel? foundToday;

        for (var checkIn in history) {
          final DateTime? checkInDate = checkIn.createdAt != null
              ? DateTime.tryParse(checkIn.createdAt!)?.toLocal()
              : null;
          if (checkInDate != null) {
            checkInDates.add(checkInDate);
            checkInMoods.add(checkIn.feeling ?? '');

            if (checkInDate.year == today.year &&
                checkInDate.month == today.month &&
                checkInDate.day == today.day) {
              foundToday = checkIn;
            }
          }
        }

        todayCheckIn.value = foundToday;
        if (foundToday != null) {
          latestMood.value = foundToday.feeling ?? '';
        }

        await StorageUtils.write(moodHistoryCacheKey, response.data!.toJson());
        if (response.lastUpdated != null) {
          await StorageUtils.write(
            moodHistoryLastUpdatedKey,
            response.lastUpdated!.toIso8601String(),
          );
        }

        fetchMoodTrackerStats();
      }
    } catch (e) {
      Get.log("Error fetching mood history: $e");
    }
  }

  Future<bool> updateUserProfile({
    String? name,
    String? gender,
    int? age,
    String? email,
    String? address,
    double? height,
    double? weight,
    String? phoneNumber,
  }) async {
    try {
      isLoadingProfile.value = true;

      // Update attributes
      final profileRes = await ProfileService.updateProfile(
        name: name,
        gender: gender,
        age: age,
        email: email,
        address: address,
        height: height,
        weight: weight,
        phoneNumber: phoneNumber,
      );

      if (profileRes != null && profileRes.data != null) {
        userProfile.value = profileRes.data;
      }
      return true;
    } catch (e) {
      Get.log("Error updating user profile: $e");
      return false;
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void addMoodCheckin(String mood) {
    latestMood.value = mood;
    final today = DateTime.now();

    // Check if already checked in today
    bool alreadyCheckedIn = checkInDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );

    if (!alreadyCheckedIn) {
      checkInDates.add(today);
      checkInMoods.add(mood);
    } else {
      // Update latest mood for today
      int idx = checkInDates.indexWhere(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
      if (idx != -1) {
        checkInMoods[idx] = mood;
      }
    }

    // Trigger forceRefresh to fetch latest state from server and update local cache
    fetchMoodHistory(forceRefresh: true);
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.fetchStreakStats(forceRefresh: true);
      homeController.fetchDailyPlan(forceRefresh: true);
    }
  }

  Future<void> changeDateFilter(DateFilter filter) async {
    selectedDateFilter.value = filter;
    await fetchMoodHistory();
  }

  Future<bool> uploadProfilePicture(String filePath, String fileName) async {
    Get.log(
      "globalController: uploadProfilePicture called with path=$filePath, name=$fileName",
    );
    final userId = userProfile.value?.userId;
    Get.log(
      "globalController: userProfile is ${userProfile.value?.toJson()}, userId is $userId",
    );
    if (userId == null) {
      Get.log("globalController: userId is null!");
      return false;
    }
    if (userId == 0) {
      Get.log(
        "globalController: Warning! userId is 0, which might indicate a parsing error or missing ID.",
      );
    }
    try {
      Get.log(
        "globalController: calling ProfileService.uploadProfilePicture for userId=$userId",
      );
      final picRes = await ProfileService.uploadProfilePicture(
        userId: userId,
        filePath: filePath,
        fileName: fileName,
      );
      Get.log(
        "globalController: ProfileService.uploadProfilePicture response: $picRes",
      );
      if (picRes != null && picRes.data != null) {
        userProfile.value = picRes.data;
        return true;
      }
    } catch (e) {
      Get.log("Error uploading profile picture: $e");
    }
    return false;
  }

  Future<bool> deleteProfilePicture() async {
    final userId = userProfile.value?.userId;
    if (userId == null) return false;
    try {
      final picRes = await ProfileService.deleteProfilePicture(userId: userId);
      if (picRes != null && picRes.data != null) {
        userProfile.value = picRes.data;
        return true;
      }
    } catch (e) {
      Get.log("Error deleting profile picture: $e");
    }
    return false;
  }

  Future<void> fetchMoodTrackerStats({
    String? dateFilter,
    String? fromDate,
    String? toDate,
    bool forceRefresh = false,
  }) async {
    if (_isFetchingHistory) return;
    final String actualFilter = dateFilter ?? "thisWeek";
    final String suffix = fromDate != null || toDate != null
        ? '${fromDate}_$toDate'
        : actualFilter;
    final String cacheKey = 'insights_mood_tracker_$suffix';
    final String lastUpdatedKey = 'insights_mood_tracker_last_updated_$suffix';

    try {
      // 1. Try to load from local cache first
      final cachedData = StorageUtils.read<Map<String, dynamic>>(cacheKey);
      final cachedLastUpdated = StorageUtils.read<String>(lastUpdatedKey);

      bool hasCache = cachedData != null && cachedLastUpdated != null;
      if (hasCache) {
        final model = MoodTrackerStatsModel.fromJson(cachedData);
        if (actualFilter == "thisWeek" && fromDate == null && toDate == null) {
          moodTrackerStatsThisWeek.value = model;
        }
        moodTrackerStats.value = model;
        hasCache = true;
      }

      if (!hasCache) {
        isLoadingMoodTracker.value = true;
      }

      if (hasCache && !forceRefresh) {
        // Perform lightweight check Res
        final checkRes = await InsightsService.getMoodTrackerStats(
          fromDate: fromDate,
          toDate: toDate,
          dateFilter: actualFilter,
          timezone: 'UTC',
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(
            cachedLastUpdated!,
          );
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date! Stop here.
            return;
          }
        }
      }

      // Fetch fresh data
      final res = await InsightsService.getMoodTrackerStats(
        fromDate: fromDate,
        toDate: toDate,
        dateFilter: actualFilter,
        timezone: 'UTC',
      );
      if (res != null && res.data != null) {
        if (actualFilter == "thisWeek" && fromDate == null && toDate == null) {
          moodTrackerStatsThisWeek.value = res.data;
        }
        moodTrackerStats.value = res.data;
        await StorageUtils.write(cacheKey, res.data!.toJson());
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            lastUpdatedKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Error fetching global mood tracker stats: $e");
    } finally {
      isLoadingMoodTracker.value = false;
    }
  }

  Future<void> fetchFeaturedMeditations({bool forceRefresh = false}) async {
    try {
      // 1. Try to load from cache
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(
        _featuredMeditationsCacheKey,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        _featuredMeditationsLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        featuredMeditations.assignAll(
          cachedData
              .map(
                (e) => MeditationSessionModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList(),
        );
        hasCache = true;
      }

      if (hasCache) {
        isLoadingFeaturedMeditations.value = false;
      } else {
        isLoadingFeaturedMeditations.value = true;
      }

      // 2. Perform lightweight timestamp verification check if not force-refreshing
      if (hasCache && !forceRefresh) {
        final checkRes = await MeditationService.getFeaturedMeditations(
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            return;
          }
        }
      }

      // 3. Fetch fresh data
      final res = await MeditationService.getFeaturedMeditations();
      if (res != null && res.data != null) {
        featuredMeditations.assignAll(res.data!);
        await StorageUtils.write(
          _featuredMeditationsCacheKey,
          res.data!.map((e) => e.toJson()).toList(),
        );
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            _featuredMeditationsLastUpdatedKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Error fetching featured meditations: $e");
    } finally {
      isLoadingFeaturedMeditations.value = false;
    }
  }
}
