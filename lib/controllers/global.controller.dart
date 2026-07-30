import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';

class GlobalController extends GetxController {
  final RxBool isLoadingMoodTracker = false.obs;
  final Rxn<MoodTrackerStatsModel> moodTrackerStats = Rxn<MoodTrackerStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchMoodTrackerStats();
  }

  Future<void> fetchMoodTrackerStats() async {
    try {
      isLoadingMoodTracker.value = true;
      final response = await InsightsService.getMoodTrackerStats(
        range: 'weekly',
        timezone: 'UTC',
      );
      if (response != null && response.data != null) {
        moodTrackerStats.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching global mood tracker stats: $e");
    } finally {
      isLoadingMoodTracker.value = false;
    }
  }
}
