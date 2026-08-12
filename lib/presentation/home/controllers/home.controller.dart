import 'package:Mentora/controllers/global.controller.dart';
import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:Mentora/data/model/plan.model.dart';
import 'package:Mentora/infrastructure/dal/services/tasks_service.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/data/model/streak_stats.model.dart';

class HomeController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  final RxInt streakCount = 0.obs;
  final RxInt weeklyCheckInCount = 0.obs;

  static const String _streakStatsCacheKey = 'home_streak_stats_data';
  static const String _streakStatsLastUpdatedCacheKey = 'home_streak_stats_last_updated';
  static const String _dailyPlanCacheKey = 'home_daily_plan_data';

  // Trusted Contact Info
  final RxString trustedContactName = ''.obs;
  final RxString trustedContactPhone = ''.obs;

  final RxList<PlanModel> plans = <PlanModel>[].obs;
  final RxBool isLoadingPlans = false.obs;

  void updateTrustedContact(String name, String phone) {
    trustedContactName.value = name;
    trustedContactPhone.value = phone;
    AppMethod.saveTrustedContact(name, phone);
  }

  @override
  void onInit() {
    super.onInit();

    Future.wait([fetchStreakStats(), fetchDailyPlan()]);
  }

  Future<void> fetchStreakStats({bool forceRefresh = false}) async {
    try {
      // 1. Try to load stats from cache first
      final cachedStats = StorageUtils.read<Map<String, dynamic>>(_streakStatsCacheKey);
      final cachedLastUpdated = StorageUtils.read<String>(_streakStatsLastUpdatedCacheKey);

      bool hasCache = cachedStats != null && cachedLastUpdated != null;
      if (hasCache) {
        final stats = StreakStatsModel.fromJson(cachedStats);
        streakCount.value = stats.currentStreak ?? 0;
        weeklyCheckInCount.value = stats.weeklyCheckInCount ?? 0;
      }

      // 2. Perform lightweight timestamp verification check if not force-refreshing
      if (hasCache && !forceRefresh) {
        final checkRes = await AssessmentService.getStreakStats(
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date! Stop here.
            return;
          }
        }
      }

      // 3. Fetch fresh stats
      final response = await AssessmentService.getStreakStats();
      if (response != null && response.data != null) {
        final stats = response.data!;
        streakCount.value = stats.currentStreak ?? 0;
        weeklyCheckInCount.value = stats.weeklyCheckInCount ?? 0;

        await StorageUtils.write(_streakStatsCacheKey, stats.toJson());
        if (response.lastUpdated != null) {
          await StorageUtils.write(
            _streakStatsLastUpdatedCacheKey,
            response.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Error fetching streak stats: $e");
    }
  }

  Future<void> fetchDailyPlan({bool forceRefresh = false}) async {
    try {
      // 1. Try to load plans from cache first
      final cachedPlans = StorageUtils.read<List<dynamic>>(_dailyPlanCacheKey);
      bool hasCache = cachedPlans != null;
      if (hasCache) {
        final List<PlanModel> list = cachedPlans
            .map((e) => PlanModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        plans.assignAll(list);
      }

      if (!hasCache || forceRefresh) {
        isLoadingPlans.value = true;
      }

      // 2. Fetch fresh plans
      final response = await TasksService.getDailyPlan(timezone: 'UTC');
      if (response != null && response.data != null) {
        plans.assignAll(response.data!);
        final serializedPlans = response.data!.map((e) => e.toJson()).toList();
        await StorageUtils.write(_dailyPlanCacheKey, serializedPlans);
      }
    } catch (e) {
      Get.log("Error fetching daily plan: $e");
    } finally {
      isLoadingPlans.value = false;
    }
  }

  Future<void> togglePlanCompletion(int index) async {
    if (index >= 0 && index < plans.length) {
      final plan = plans[index];
      final newStatus = !(plan.isComplete ?? false);

      // Optimistically update UI
      final updatedPlan = PlanModel(
        id: plan.id,
        activityId: plan.activityId,
        title: plan.title,
        caption: plan.caption,
        icon: plan.icon,
        duration: plan.duration,
        category: plan.category,
        sortOrder: plan.sortOrder,
        isComplete: newStatus,
      );
      plans[index] = updatedPlan;
      plans.refresh();

      try {
        final response = await TasksService.updatePlanItemCompletion(
          planItemId: plan.id ?? 0,
          isComplete: newStatus,
        );
        if (response != null && response.data != null) {
          plans[index] = response.data!;
          plans.refresh();
        }
      } catch (e) {
        Get.log("Error updating plan item status: $e");
        // Revert back on error
        plans[index] = plan;
        plans.refresh();
      }
    }
  }
}
