import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';

class GlobalController extends GetxController {
  bool _isFetchingHistory = false;
  final RxBool isLoadingMoodTracker = false.obs;
  final Rxn<MoodTrackerStatsModel> moodTrackerStats = Rxn<MoodTrackerStatsModel>();
  final Rxn<MoodTrackerStatsModel> weeklyMoodStats = Rxn<MoodTrackerStatsModel>();
  final Rxn<MoodTrackerStatsModel> monthlyMoodStats = Rxn<MoodTrackerStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchMoodTrackerStats();
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
      
      final weeklyRes = await InsightsService.getMoodTrackerStats(
        range: 'weekly',
        timezone: 'UTC',
      );
      if (weeklyRes != null && weeklyRes.data != null) {
        weeklyMoodStats.value = weeklyRes.data;
        moodTrackerStats.value = weeklyRes.data;
      }

      final monthlyRes = await InsightsService.getMoodTrackerStats(
        range: 'monthly',
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
