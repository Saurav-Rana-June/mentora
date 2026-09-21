import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/video_session.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/video_session_service.dart';

class AdminVideoSessionController extends GetxController {
  final RxList<VideoSessionModel> sessions = <VideoSessionModel>[].obs;
  final RxList<String> categories = <String>['All'].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchSessions();
  }

  Future<void> fetchCategories() async {
    try {
      final res = await VideoSessionService.getVideoSessionFilters();
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

  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      final res = await VideoSessionService.getVideoSessions(
        category: selectedCategory.value,
        search: searchQuery.value,
      );
      if (res?.data != null) {
        sessions.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching video sessions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    fetchSessions();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchSessions();
  }

  Future<bool> createSession({
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String videoLink,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'videoLink': videoLink,
        'description': description,
      };

      final res = await VideoSessionService.createVideoSession(body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Video session created', SnackBarType.SUCCESS);
        await fetchSessions();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateSession({
    required int id,
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String videoLink,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final body = {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'videoLink': videoLink,
        'description': description,
      };

      final res = await VideoSessionService.updateVideoSession(id, body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Video session updated', SnackBarType.SUCCESS);
        await fetchSessions();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteSession(int id) async {
    final res = await VideoSessionService.deleteVideoSession(id);
    if (res != null) {
      sessions.removeWhere((s) => s.id == id);
      AppUtils.snackbar('Deleted', 'Video session deleted', SnackBarType.INFO);
      return true;
    }
    return false;
  }
}
