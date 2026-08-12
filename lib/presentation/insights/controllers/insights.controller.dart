import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/model/growth_areas_response.model.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/coaching_banner_response.model.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';

class InsightsController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
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
    globalController.fetchMoodTrackerStats(dateFilter: initialFilter.name);
    fetchCoachingBanner();
  }

  static const String _coachingBannerCacheKey = 'insights_coaching_banner_data';
  static const String _coachingBannerLastUpdatedKey =
      'insights_coaching_banner_last_updated';

  Future<void> fetchCoachingBanner({bool forceRefresh = false}) async {
    try {
      final cachedData = StorageUtils.read<Map<String, dynamic>>(
        _coachingBannerCacheKey,
      );
      final cachedLastUpdated = StorageUtils.read<String>(
        _coachingBannerLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        coachingBannerData.value = CoachingBannerResponseModel.fromJson(
          cachedData,
        );
        hasCache = true;
      }

      if (!hasCache) {
        isLoadingCoachingBanner.value = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await InsightsService.getCoachingBanner(
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

      final response = await InsightsService.getCoachingBanner(timezone: 'UTC');
      if (response != null && response.data != null) {
        coachingBannerData.value = response.data;
        await StorageUtils.write(
          _coachingBannerCacheKey,
          response.data!.toJson(),
        );
        if (response.lastUpdated != null) {
          await StorageUtils.write(
            _coachingBannerLastUpdatedKey,
            response.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Error fetching coaching banner: $e");
    } finally {
      isLoadingCoachingBanner.value = false;
    }
  }

  Future<void> fetchGrowthAreas(
    DateFilter filter, {
    bool forceRefresh = false,
  }) async {
    final String growthAreasCacheKey = 'insights_growth_areas_${filter.name}';
    final String growthAreasLastUpdatedKey =
        'insights_growth_areas_last_updated_${filter.name}';

    try {
      final cachedData = StorageUtils.read<Map<String, dynamic>>(
        growthAreasCacheKey,
      );
      final cachedLastUpdated = StorageUtils.read<String>(
        growthAreasLastUpdatedKey,
      );

      bool hasCache = false;
      if (cachedData != null && cachedLastUpdated != null) {
        final model = GrowthAreasResponseModel.fromJson(cachedData);
        _growthAreasCache[filter] = model;
        if (selectedDateFilter.value == filter) {
          growthAreasData.value = model;
        }
        hasCache = true;
      }

      if (selectedDateFilter.value == filter && !hasCache) {
        isLoadingGrowth.value = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await InsightsService.getGrowthAreas(
          dateFilter: filter.name,
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

      final response = await InsightsService.getGrowthAreas(
        dateFilter: filter.name,
        timezone: 'UTC',
      );
      if (response != null && response.data != null) {
        _growthAreasCache[filter] = response.data!;
        if (selectedDateFilter.value == filter) {
          growthAreasData.value = response.data;
        }
        await StorageUtils.write(growthAreasCacheKey, response.data!.toJson());
        if (response.lastUpdated != null) {
          await StorageUtils.write(
            growthAreasLastUpdatedKey,
            response.lastUpdated!.toIso8601String(),
          );
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
