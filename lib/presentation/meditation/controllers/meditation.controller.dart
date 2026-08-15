import 'dart:async';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/data/model/meditation_session.model.dart';
import '../../../infrastructure/dal/services/meditation_service.dart';

class MeditationController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxSet<String> favoritedIds = {'1', '3'}.obs;

  // API list buffers
  final RxList<MeditationSessionModel> allSessionsList =
      <MeditationSessionModel>[].obs;

  final RxList<String> categoriesList = <String>[].obs;

  // Cache keys constants
  static const String _categoriesCacheKey = StorageKeys.MEDITATION_CATEGORIES;
  static const String _categoriesLastUpdatedCacheKey =
      StorageKeys.MEDITATION_CATEGORIES_LAST_UPDATED;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch of filters and sessions
    Future.wait([fetchFilters(), fetchSessions()]);

    // React to category changes
    ever(selectedCategory, (_) => fetchSessions());

    // React to search queries with 300ms debounce to prevent spamming the backend
    debounce(
      searchQuery,
      (_) => fetchSessions(),
      time: const Duration(milliseconds: 300),
    );
  }

  /// Fetch available category filters from the API (with local caching)
  Future<void> fetchFilters({bool forceRefresh = false}) async {
    try {
      // 1. Try to load categories filters from cache first
      final List<dynamic>? cachedCategories = StorageUtils.read<List<dynamic>>(
        _categoriesCacheKey,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        _categoriesLastUpdatedCacheKey,
      );

      bool hasCache = false;
      if (cachedCategories != null &&
          cachedCategories.isNotEmpty &&
          cachedLastUpdated != null) {
        categoriesList.assignAll(
          cachedCategories.map((e) => e.toString()).toList(),
        );
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        // Fetch only the lastUpdated timestamp from the API to check if it changed
        final checkRes = await MeditationService.getMeditationFilters(
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

      // 2. Fetch fresh categories filters from the API in the background
      final res = await MeditationService.getMeditationFilters();
      if (res != null && res.data != null) {
        categoriesList.assignAll(res.data!);
        // Save to cache
        await StorageUtils.write(_categoriesCacheKey, res.data!);
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            _categoriesLastUpdatedCacheKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
    } catch (e) {
      Get.log("Failed to load meditation filters: $e");
    }
  }

  /// Fetch meditations from the API based on selected filters and queries (with local caching)
  Future<void> fetchSessions({bool forceRefresh = false}) async {
    final String allCacheKey = StorageKeys.meditationAll(
      selectedCategory.value,
      searchQuery.value,
    );
    final String allLastUpdatedCacheKey = StorageKeys.meditationAllLastUpdated(
      selectedCategory.value,
      searchQuery.value,
    );

    if (forceRefresh) {
      await StorageUtils.remove(allCacheKey);
      await StorageUtils.remove(allLastUpdatedCacheKey);
    }

    try {
      // 1. Check cache first
      final List<dynamic>? cachedAll = StorageUtils.read<List<dynamic>>(
        allCacheKey,
      );
      final String? cachedAllLastUpdated = StorageUtils.read<String>(
        allLastUpdatedCacheKey,
      );

      bool hasAllCache = cachedAll != null && cachedAllLastUpdated != null;

      if (hasAllCache) {
        final List<MeditationSessionModel> allList = cachedAll
            .map(
              (e) =>
                  MeditationSessionModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
        allSessionsList.assignAll(allList);
      }

      if (hasAllCache) {
        isLoading.value = false; // Show cached/memory data instantly
      }

      bool needFetchAll = !hasAllCache || forceRefresh;

      // 2. Perform lightweight timestamp checks if not force-refreshing
      if (hasAllCache && !forceRefresh) {
        final checkRes = await MeditationService.getMeditations(
          category: selectedCategory.value,
          search: searchQuery.value,
          lastUpdated: cachedAllLastUpdated,
        );
        if (checkRes == null ||
            checkRes.lastUpdated == null ||
            checkRes.lastUpdated != DateTime.tryParse(cachedAllLastUpdated)) {
          needFetchAll = true;
        }
      }

      if (!needFetchAll) {
        // Cache is fully up-to-date! Stop here.
        return;
      }

      if (needFetchAll && !hasAllCache) {
        isLoading.value = true;
      }

      // 3. Execute API call in the background to fetch all meditations
      if (needFetchAll) {
        final allRes = await MeditationService.getMeditations(
          category: selectedCategory.value,
          search: searchQuery.value,
        );

        // Update and cache all meditations, and update lastUpdated timestamp cache
        if (allRes != null && allRes.data != null) {
          allSessionsList.assignAll(allRes.data!);
          final serializedAll = allRes.data!.map((e) => e.toJson()).toList();
          await StorageUtils.write(allCacheKey, serializedAll);

          if (allRes.lastUpdated != null) {
            await StorageUtils.write(
              allLastUpdatedCacheKey,
              allRes.lastUpdated!.toIso8601String(),
            );
          }
        }
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
  List<MeditationSessionModel> get filteredSessions => allSessionsList;

  // Derived RxBool that synchronizes with the favoritedIds reactive set
  RxBool getIsFavoritedRx(String id) {
    final rx = favoritedIds.contains(id).obs;
    favoritedIds.listen((set) {
      rx.value = set.contains(id);
    });
    return rx;
  }
}
