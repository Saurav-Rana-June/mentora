import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/data/model/auth/profile.model.dart';
import 'package:Mentora/infrastructure/dal/services/profile_service.dart';

class GlobalController extends GetxController {
  bool _isFetchingHistory = false;
  final RxBool isLoadingMoodTracker = false.obs;
  final Rxn<MoodTrackerStatsModel> moodTrackerStats =
      Rxn<MoodTrackerStatsModel>();

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
  }) async {
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

      final res = await InsightsService.getMoodTrackerStats(
        fromDate: fromDate,
        toDate: toDate,
        dateFilter: dateFilter ?? "thisWeek",
        timezone: 'UTC',
      );
      if (res != null && res.data != null) {
        moodTrackerStats.value = res.data;
      }
    } catch (e) {
      Get.log("Error fetching global mood tracker stats: $e");
    } finally {
      isLoadingMoodTracker.value = false;
    }
  }
}
