import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  // GetStorage box instance
  final GetStorage _box = GetStorage();

  // Cache keys constants
  static const String _categoriesCacheKey = 'meditation_categories_filters';

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

  /// Fetch available category filters from the API (with local caching)
  Future<void> fetchFilters() async {
    try {
      // 1. Try to load categories filters from cache first
      final List<dynamic>? cachedCategories = _box.read<List<dynamic>>(_categoriesCacheKey);
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        categoriesList.assignAll(cachedCategories.map((e) => e.toString()).toList());
      }

      // 2. Fetch fresh categories filters from the API in the background
      final res = await MeditationService.getMeditationFilters();
      if (res != null && res.data != null) {
        categoriesList.assignAll(res.data!);
        // Save to cache
        await _box.write(_categoriesCacheKey, res.data!);
      }
    } catch (e) {
      Get.log("Failed to load meditation filters: $e");
    }
  }

  /// Fetch meditations from the API based on selected filters and queries (with local caching)
  Future<void> fetchSessions({bool forceRefresh = false}) async {
    final String allCacheKey = 'meditations_all_${selectedCategory.value}_${searchQuery.value}';
    final String featuredCacheKey = 'meditations_featured_${selectedCategory.value}_${searchQuery.value}';
    final String lastUpdatedCacheKey = 'meditations_last_updated_${selectedCategory.value}_${searchQuery.value}';

    try {
      // 1. Check cache first
      final List<dynamic>? cachedAll = _box.read<List<dynamic>>(allCacheKey);
      final List<dynamic>? cachedFeatured = _box.read<List<dynamic>>(featuredCacheKey);
      final String? cachedLastUpdated = _box.read<String>(lastUpdatedCacheKey);

      bool hasCache = false;
      if (cachedAll != null && cachedFeatured != null && cachedLastUpdated != null) {
        final List<MeditationSession> allList = cachedAll
            .map((e) => MeditationSession.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        final List<MeditationSession> featuredList = cachedFeatured
            .map((e) => MeditationSession.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        allSessionsList.assignAll(allList);
        featuredSessionsList.assignAll(featuredList);
        isLoading.value = false; // Show data instantly from cache/memory
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        // Fetch only the lastUpdated timestamp from the API to check if it changed
        final checkRes = await MeditationService.getMeditations(
          category: selectedCategory.value,
          search: searchQuery.value,
          lastUpdated: cachedLastUpdated,
        );

        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            // Cache is up to date! Stop here.
            return;
          }
        }
      } else if (!hasCache) {
        // If no cache, show loading skeleton
        isLoading.value = true;
      }

      // 2. Execute parallel API calls in the background to fetch full lists
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

      // Update and cache featured meditations
      if (featuredRes != null && featuredRes.data != null) {
        featuredSessionsList.assignAll(featuredRes.data!);
        final serializedFeatured = featuredRes.data!.map((e) => e.toJson()).toList();
        await _box.write(featuredCacheKey, serializedFeatured);
      }

      // Update and cache all meditations, and update lastUpdated timestamp cache
      if (allRes != null && allRes.data != null) {
        allSessionsList.assignAll(allRes.data!);
        final serializedAll = allRes.data!.map((e) => e.toJson()).toList();
        await _box.write(allCacheKey, serializedAll);

        if (allRes.lastUpdated != null) {
          await _box.write(lastUpdatedCacheKey, allRes.lastUpdated!.toIso8601String());
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
  List<MeditationSession> get filteredSessions => allSessionsList;
  List<MeditationSession> get featuredSessions => featuredSessionsList;

  // Derived RxBool that synchronizes with the favoritedIds reactive set
  RxBool getIsFavoritedRx(String id) {
    final rx = favoritedIds.contains(id).obs;
    favoritedIds.listen((set) {
      rx.value = set.contains(id);
    });
    return rx;
  }
}
