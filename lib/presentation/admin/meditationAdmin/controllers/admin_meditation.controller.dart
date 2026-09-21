import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/meditation_session.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/meditation_service.dart';

class AdminMeditationsController extends GetxController {
  final RxList<MeditationSessionModel> meditations = <MeditationSessionModel>[].obs;
  final RxList<String> categories = <String>['All'].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchMeditations();
  }

  Future<void> fetchCategories() async {
    try {
      final res = await MeditationService.getMeditationFilters();
      if (res?.data != null && res!.data!.isNotEmpty) {
        final list = res.data!;
        if (!list.contains('All')) {
          categories.assignAll(['All', ...list]);
        } else {
          categories.assignAll(list);
        }
      }
    } catch (_) {}
  }

  Future<void> fetchMeditations() async {
    try {
      isLoading.value = true;
      final res = await MeditationService.getMeditations(
        category: selectedCategory.value,
        search: searchQuery.value,
      );
      if (res?.data != null) {
        meditations.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching meditations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    fetchMeditations();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchMeditations();
  }

  Future<bool> createMeditation({
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required bool isFeatured,
    required String description,
    required String soundTrack,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'isFeatured': isFeatured,
        'description': description,
        'soundTrack': soundTrack,
      };

      final res = await MeditationService.createMeditation(body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Meditation created successfully', SnackBarType.SUCCESS);
        await fetchMeditations();
        return true;
      }
      return false;
    } catch (e) {
      Get.log('Error creating meditation: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateMeditation({
    required int id,
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required bool isFeatured,
    required String description,
    required String soundTrack,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'isFeatured': isFeatured,
        'description': description,
        'soundTrack': soundTrack,
      };

      final res = await MeditationService.updateMeditation(id, body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Meditation updated successfully', SnackBarType.SUCCESS);
        await fetchMeditations();
        return true;
      }
      return false;
    } catch (e) {
      Get.log('Error updating meditation: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteMeditation(int id) async {
    try {
      final res = await MeditationService.deleteMeditation(id);
      if (res != null) {
        meditations.removeWhere((item) => item.id == id);
        AppUtils.snackbar('Deleted', 'Meditation session deleted', SnackBarType.INFO);
        return true;
      }
      return false;
    } catch (e) {
      Get.log('Error deleting meditation: $e');
      return false;
    }
  }
}
