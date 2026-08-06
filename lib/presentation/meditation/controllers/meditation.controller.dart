import 'dart:async';
import 'package:get/get.dart';
import '../widgets/meditation_session.dart';
import '../../../infrastructure/dal/services/meditation_service.dart';

class MeditationController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxSet<String> favoritedIds = {'1', '3'}.obs;

  // API list buffers
  final RxList<MeditationSession> allSessionsList = <MeditationSession>[].obs;
  final RxList<MeditationSession> featuredSessionsList = <MeditationSession>[].obs;
  final RxList<String> categoriesList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch of filters and sessions
    fetchFilters();
    fetchSessions();

    // React to category changes
    ever(selectedCategory, (_) => fetchSessions());

    // React to search queries with 300ms debounce to prevent spamming the backend
    debounce(searchQuery, (_) => fetchSessions(), time: const Duration(milliseconds: 300));
  }

  /// Fetch available category filters from the API
  Future<void> fetchFilters() async {
    try {
      final res = await MeditationService.getMeditationFilters();
      if (res != null && res.data != null) {
        categoriesList.value = res.data!;
      }
    } catch (e) {
      Get.log("Failed to load meditation filters: $e");
    }
  }

  /// Fetch meditations from the API based on selected filters and queries
  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      
      // Perform parallel queries for featured and general list
      final results = await Future.wait([
        MeditationService.getFeaturedMeditations(
          category: selectedCategory.value,
          search: searchQuery.value,
        ),
        MeditationService.getMeditations(
          category: selectedCategory.value,
          search: searchQuery.value,
        ),
      ]);

      final featuredRes = results[0];
      final allRes = results[1];

      if (featuredRes != null && featuredRes.data != null) {
        featuredSessionsList.assignAll(featuredRes.data!);
      }
      if (allRes != null && allRes.data != null) {
        allSessionsList.assignAll(allRes.data!);
      }
    } catch (e) {
      Get.log("Failed to load meditations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle session favorite status
  void toggleFavorite(String id) {
    if (favoritedIds.contains(id)) {
      favoritedIds.remove(id);
    } else {
      favoritedIds.add(id);
    }
  }

  // Set selected category filter
  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // Update query search string
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // UI-compatible getters pointing to reactive API datasets
  List<MeditationSession> get filteredSessions => allSessionsList;
  List<MeditationSession> get featuredSessions => featuredSessionsList;
}
