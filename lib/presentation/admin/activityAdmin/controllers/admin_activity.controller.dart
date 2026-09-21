import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/activity.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/tasks_service.dart';

class AdminActivityController extends GetxController {
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final List<String> categories = [
    'All',
    'breathing',
    'meditation',
    'journaling',
    'sleep',
    'movement',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      isLoading.value = true;
      final res = await TasksService.getAdminActivities(
        category: selectedCategory.value,
      );
      if (res?.data != null) {
        activities.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching admin activities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ActivityModel> get filteredActivities {
    if (searchQuery.value.isEmpty) return activities;
    final query = searchQuery.value.toLowerCase();
    return activities.where((act) {
      return act.title.toLowerCase().contains(query) ||
          act.caption.toLowerCase().contains(query) ||
          act.category.toLowerCase().contains(query);
    }).toList();
  }

  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    fetchActivities();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<bool> createActivity(Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;
      final res = await TasksService.createActivity(body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Activity added to catalog', SnackBarType.SUCCESS);
        await fetchActivities();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateActivity(int id, Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;
      final res = await TasksService.updateActivity(id, body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Activity updated', SnackBarType.SUCCESS);
        await fetchActivities();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteActivity(int id) async {
    final res = await TasksService.deleteActivity(id);
    if (res != null) {
      activities.removeWhere((a) => a.id == id);
      AppUtils.snackbar('Deleted', 'Activity archived from daily plans', SnackBarType.INFO);
      return true;
    }
    return false;
  }
}
