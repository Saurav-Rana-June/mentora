import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/breathing_pattern.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/breathing_service.dart';

class AdminBreathingController extends GetxController {
  final RxList<BreathingPatternModel> patterns = <BreathingPatternModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatterns();
  }

  Future<void> fetchPatterns() async {
    try {
      isLoading.value = true;
      final res = await BreathingService.getBreathingPatterns(
        search: searchQuery.value,
      );
      if (res?.data != null) {
        patterns.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching breathing patterns: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchPatterns();
  }

  Future<bool> createPattern({
    required String name,
    required String description,
    required int inhale,
    required int holdIn,
    required int exhale,
    required int holdOut,
    required String icon,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'name': name,
        'description': description,
        'inhale': inhale,
        'holdIn': holdIn,
        'exhale': exhale,
        'holdOut': holdOut,
        'icon': icon,
      };

      final res = await BreathingService.createBreathingTechnique(body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Breathing technique created', SnackBarType.SUCCESS);
        await fetchPatterns();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updatePattern({
    required int id,
    required String name,
    required String description,
    required int inhale,
    required int holdIn,
    required int exhale,
    required int holdOut,
    required String icon,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'name': name,
        'description': description,
        'inhale': inhale,
        'holdIn': holdIn,
        'exhale': exhale,
        'holdOut': holdOut,
        'icon': icon,
      };

      final res = await BreathingService.updateBreathingTechnique(id, body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Breathing technique updated', SnackBarType.SUCCESS);
        await fetchPatterns();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deletePattern(int id) async {
    final res = await BreathingService.deleteBreathingTechnique(id);
    if (res != null) {
      patterns.removeWhere((p) => p.id == id);
      AppUtils.snackbar('Deleted', 'Breathing technique deleted', SnackBarType.INFO);
      return true;
    }
    return false;
  }
}
