import 'package:get/get.dart';
import 'package:Mentora/data/model/assessment/growth_areas_response.model.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/assessment/mood_tracker_stats.model.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';

class InsightsController extends GetxController {
  final RxInt selectedGrowthTab = 0.obs;
  final RxInt selectedMoodTab = 0.obs;

  final RxBool isLoadingGrowth = false.obs;
  final Rxn<GrowthAreasResponseModel> growthAreasData = Rxn<GrowthAreasResponseModel>();

  final Rx<DateFilter> selectedDateFilter = DateFilter.thisWeek.obs;
  final Rxn<MoodTrackerStatsModel> moodStats = Rxn<MoodTrackerStatsModel>();
  final RxBool isLoadingMoodStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrowthAreas();
    fetchMoodStats();
  }

  Future<void> fetchGrowthAreas() async {
    try {
      isLoadingGrowth.value = true;
      final response = await InsightsService.getGrowthAreas(timezone: 'UTC');
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
      final range = _getDateRange(selectedDateFilter.value);
      final response = await InsightsService.getMoodTrackerStats(
        fromDate: range['from']!,
        toDate: range['to']!,
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
  }

  Map<String, String> _getDateRange(DateFilter filter) {
    final now = DateTime.now().toUtc();
    DateTime from;
    DateTime to = now;

    switch (filter) {
      case DateFilter.thisWeek:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        from = monday;
        to = sunday;
        break;
      case DateFilter.thisMonth:
        from = DateTime(now.year, now.month, 1);
        final nextMonth = DateTime(now.year, now.month + 1, 1);
        to = nextMonth.subtract(const Duration(days: 1));
        break;
      case DateFilter.lastMonth:
        from = DateTime(now.year, now.month - 1, 1);
        to = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        break;
      case DateFilter.last3Month:
        from = now.subtract(const Duration(days: 90));
        to = now;
        break;
      case DateFilter.last6Month:
        from = now.subtract(const Duration(days: 180));
        to = now;
        break;
      case DateFilter.thisYear:
        from = DateTime(now.year, 1, 1);
        to = DateTime(now.year, 12, 31);
        break;
      case DateFilter.lastYear:
        from = DateTime(now.year - 1, 1, 1);
        to = DateTime(now.year - 1, 12, 31);
        break;
      case DateFilter.allTime:
        from = DateTime(2020, 1, 1);
        to = now;
        break;
    }

    String formatDate(DateTime date) {
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }

    return {
      'from': formatDate(from),
      'to': formatDate(to),
    };
  }

  void toggleGrowthTab(int index) {
    selectedGrowthTab.value = index;
  }

  void toggleMoodTab(int index) {
    selectedMoodTab.value = index;
  }
}
