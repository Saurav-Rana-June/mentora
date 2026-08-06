import 'package:get/get.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/model/assessment/growth_areas_response.model.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/assessment/coaching_banner_response.model.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';

class InsightsController extends GetxController {
  final RxInt selectedGrowthTab = 0.obs;
  final RxInt selectedMoodTab = 0.obs;

  final RxBool isLoadingGrowth = false.obs;
  final Rxn<GrowthAreasResponseModel> growthAreasData =
      Rxn<GrowthAreasResponseModel>();

  final Rx<DateFilter> selectedDateFilter = DateFilter.thisWeek.obs;

  final Rxn<CoachingBannerResponseModel> coachingBannerData =
      Rxn<CoachingBannerResponseModel>();
  final RxBool isLoadingCoachingBanner = false.obs;

  // In-memory cache for date filters
  final Map<DateFilter, GrowthAreasResponseModel> _growthAreasCache = {};

  @override
  void onInit() {
    super.onInit();
    final initialFilter = selectedDateFilter.value;
    fetchGrowthAreas(initialFilter);
    Get.find<GlobalController>().fetchMoodTrackerStats(
      dateFilter: initialFilter.name,
    );
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

  Future<void> fetchGrowthAreas(DateFilter filter) async {
    if (_growthAreasCache.containsKey(filter)) {
      growthAreasData.value = _growthAreasCache[filter];
      return;
    }

    try {
      isLoadingGrowth.value = true;
      final response = await InsightsService.getGrowthAreas(
        dateFilter: filter.name,
        timezone: 'UTC',
      );
      if (response != null && response.data != null) {
        _growthAreasCache[filter] = response.data!;
        if (selectedDateFilter.value == filter) {
          growthAreasData.value = response.data;
        }
      }
    } catch (e) {
      Get.log("Error fetching growth areas: $e");
    } finally {
      if (selectedDateFilter.value == filter) {
        isLoadingGrowth.value = false;
      }
    }
  }

  void changeDateFilter(DateFilter filter) {
    selectedDateFilter.value = filter;
    Get.find<GlobalController>().fetchMoodTrackerStats(dateFilter: filter.name);
    fetchGrowthAreas(filter);
  }

  void toggleGrowthTab(int index) {
    selectedGrowthTab.value = index;
  }

  void toggleMoodTab(int index) {
    selectedMoodTab.value = index;
  }
}
