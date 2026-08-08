import 'package:Mentora/controllers/global.controller.dart';
import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:Mentora/data/model/tasks/plan.model.dart';
import 'package:Mentora/infrastructure/dal/services/tasks_service.dart';
import 'package:Mentora/data/methods/app_method.dart';

class HomeController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  final RxInt streakCount = 0.obs;
  final RxInt weeklyCheckInCount = 0.obs;

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

    Future.wait({fetchStreakStats(), fetchDailyPlan()});
  }

  Future<void> fetchStreakStats() async {
    try {
      final response = await AssessmentService.getStreakStats();
      if (response != null && response.data != null) {
        final stats = response.data!;
        streakCount.value = stats.currentStreak ?? 0;
        weeklyCheckInCount.value = stats.weeklyCheckInCount ?? 0;
      }
    } catch (e) {
      Get.log("Error fetching streak stats: $e");
    }
  }

  Future<void> fetchDailyPlan() async {
    try {
      isLoadingPlans.value = true;
      final response = await TasksService.getDailyPlan(timezone: 'UTC');
      if (response != null && response.data != null) {
        plans.assignAll(response.data!);
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
      final newStatus = !plan.isComplete;

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
          planItemId: plan.id,
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
