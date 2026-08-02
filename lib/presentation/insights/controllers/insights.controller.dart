import 'package:get/get.dart';
import 'package:Mentora/data/model/assessment/growth_areas_response.model.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';
import 'package:Mentora/data/model/assessment/coaching_banner_response.model.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';

class InsightsController extends GetxController {
  final RxInt selectedGrowthTab = 0.obs;
  final RxInt selectedMoodTab = 0.obs;

  final RxBool isLoadingGrowth = false.obs;
  final Rxn<GrowthAreasResponseModel> growthAreasData = Rxn<GrowthAreasResponseModel>();

  final Rx<DateFilter> selectedDateFilter = DateFilter.thisWeek.obs;
  final Rxn<MoodTrackerStatsModel> moodStats = Rxn<MoodTrackerStatsModel>();
  final RxBool isLoadingMoodStats = false.obs;

  final Rxn<CoachingBannerResponseModel> coachingBannerData = Rxn<CoachingBannerResponseModel>();
  final RxBool isLoadingCoachingBanner = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrowthAreas();
    fetchMoodStats();
    fetchCoachingBanner();
  }

  Future<void> fetchCoachingBanner() async {
    try {
      isLoadingCoachingBanner.value = true;
      final response = await InsightsService.getCoachingBanner(timezone: 'UTC');
      if (response != null && response.data != null) {
        coachingBannerData.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching coaching banner: $e");
    } finally {
      isLoadingCoachingBanner.value = false;
    }
  }

  Future<void> fetchGrowthAreas() async {
    try {
      isLoadingGrowth.value = true;
      final response = await InsightsService.getGrowthAreas(
        dateFilter: selectedDateFilter.value.name,
        timezone: 'UTC',
      );
      if (response != null && response.data != null) {
        growthAreasData.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching growth areas: $e");
    } finally {
      isLoadingGrowth.value = false;
    }
  }

  Future<void> fetchMoodStats() async {
    try {
      isLoadingMoodStats.value = true;
      final response = await InsightsService.getMoodTrackerStats(
        dateFilter: selectedDateFilter.value.name,
        timezone: 'UTC',
      );
      if (response != null && response.data != null) {
        moodStats.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching mood stats: $e");
    } finally {
      isLoadingMoodStats.value = false;
    }
  }

  void changeDateFilter(DateFilter filter) {
    selectedDateFilter.value = filter;
    fetchMoodStats();
    fetchGrowthAreas();
  }

  void toggleGrowthTab(int index) {
    selectedGrowthTab.value = index;
  }

  void toggleMoodTab(int index) {
    selectedMoodTab.value = index;
  }
}
