import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/data/model/auth/profile.model.dart';
import 'package:Mentora/infrastructure/dal/services/profile_service.dart';

class GlobalController extends GetxController {
  bool _isFetchingHistory = false;
  final RxBool isLoadingMoodTracker = false.obs;
  final Rxn<MoodTrackerStatsModel> moodTrackerStats = Rxn<MoodTrackerStatsModel>();
  final Rxn<MoodTrackerStatsModel> weeklyMoodStats = Rxn<MoodTrackerStatsModel>();
  final Rxn<MoodTrackerStatsModel> monthlyMoodStats = Rxn<MoodTrackerStatsModel>();

  final Rxn<ProfileModel> userProfile = Rxn<ProfileModel>();
  final RxBool isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMoodTrackerStats();
    fetchUserProfile();
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

  Future<bool> updateUserProfile({
    String? name,
    String? gender,
    int? age,
    String? email,
    String? address,
    double? height,
    double? weight,
    String? phoneNumber,
    String? profilePictureUrl,
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

      // If profile picture is changed, update picture url as well
      if (profilePictureUrl != null && profilePictureUrl != userProfile.value?.profilePictureUrl) {
        final picRes = await ProfileService.updateProfilePicture(profilePictureUrl);
        if (picRes != null && picRes.data != null) {
          userProfile.value = picRes.data;
        }
      } else if (profileRes != null && profileRes.data != null) {
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

  Future<void> fetchMoodTrackerStats() async {
    if (_isFetchingHistory) return;
    try {
      isLoadingMoodTracker.value = true;

      try {
        _isFetchingHistory = true;
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().fetchMoodHistory();
        }
      } finally {
        _isFetchingHistory = false;
      }
      final now = DateTime.now().toUtc();
      
      // Weekly range (Monday to Sunday)
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      final weeklyFrom = "${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}";
      final weeklyTo = "${sunday.year}-${sunday.month.toString().padLeft(2, '0')}-${sunday.day.toString().padLeft(2, '0')}";

      final weeklyRes = await InsightsService.getMoodTrackerStats(
        fromDate: weeklyFrom,
        toDate: weeklyTo,
        timezone: 'UTC',
      );
      if (weeklyRes != null && weeklyRes.data != null) {
        weeklyMoodStats.value = weeklyRes.data;
        moodTrackerStats.value = weeklyRes.data;
      }

      // Monthly range (1st to last day of current month)
      final monthlyFrom = "${now.year}-${now.month.toString().padLeft(2, '0')}-01";
      final nextMonthFirstDay = DateTime(now.year, now.month + 1, 1);
      final lastDayOfMonth = nextMonthFirstDay.subtract(const Duration(days: 1));
      final monthlyTo = "${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}";

      final monthlyRes = await InsightsService.getMoodTrackerStats(
        fromDate: monthlyFrom,
        toDate: monthlyTo,
        timezone: 'UTC',
      );
      if (monthlyRes != null && monthlyRes.data != null) {
        monthlyMoodStats.value = monthlyRes.data;
      }
    } catch (e) {
      Get.log("Error fetching global mood tracker stats: $e");
    } finally {
      isLoadingMoodTracker.value = false;
    }
  }
}
