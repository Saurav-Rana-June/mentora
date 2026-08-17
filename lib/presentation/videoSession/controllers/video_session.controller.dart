import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/data/model/video_session.model.dart';
import '../../../infrastructure/dal/services/video_session_service.dart';

class VideoSessionController extends GetxController {
  final videoSessions = <VideoSessionModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final searchController = TextEditingController();

  final categories = <String>[].obs;
  final RxBool isLoading = true.obs;

  // Cache keys constants
  static const String _categoriesCacheKey = StorageKeys.VIDEO_SESSION_CATEGORIES;
  static const String _categoriesLastUpdatedCacheKey =
      StorageKeys.VIDEO_SESSION_CATEGORIES_LAST_UPDATED;

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

  /// Fetch filters/categories dynamically from the backend (with local caching)
  Future<void> fetchFilters({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await StorageUtils.remove(_categoriesCacheKey);
      await StorageUtils.remove(_categoriesLastUpdatedCacheKey);
    }
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
        categories.assignAll(
          cachedCategories.map((e) => e.toString()).toList(),
        );
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        // Fetch only the lastUpdated timestamp from the API to check if it changed
        final checkRes = await VideoSessionService.getVideoSessionFilters(
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
      final res = await VideoSessionService.getVideoSessionFilters();
      if (res != null && res.data != null) {
        categories.assignAll(res.data!);
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
      Get.log("Failed to load video session filters: $e");
    }
  }

  /// Fetch video sessions from the backend (with local caching)
  Future<void> fetchSessions({bool forceRefresh = false}) async {
    final String allCacheKey = StorageKeys.videoSessionAll(
      selectedCategory.value,
      searchQuery.value,
    );
    final String allLastUpdatedCacheKey = StorageKeys.videoSessionAllLastUpdated(
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
        final List<VideoSessionModel> allList = cachedAll
            .map(
              (e) =>
                  VideoSessionModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
        videoSessions.assignAll(allList);
      }

      if (hasAllCache) {
        isLoading.value = false; // Show cached/memory data instantly
      }

      bool needFetchAll = !hasAllCache || forceRefresh;

      // 2. Perform lightweight timestamp checks if not force-refreshing
      if (hasAllCache && !forceRefresh) {
        final checkRes = await VideoSessionService.getVideoSessions(
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

      // 3. Execute API call in the background to fetch all video sessions
      if (needFetchAll) {
        final allRes = await VideoSessionService.getVideoSessions(
          category: selectedCategory.value,
          search: searchQuery.value,
        );

        // Update and cache all video sessions, and update lastUpdated timestamp cache
        if (allRes != null && allRes.data != null) {
          videoSessions.assignAll(allRes.data!);
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
      Get.log("Failed to load video sessions from API: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<VideoSessionModel> get filteredSessions => videoSessions;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavorite(int id) {
    final index = videoSessions.indexWhere((session) => session.id == id);
    if (index != -1) {
      final session = videoSessions[index];
      session.isFavorite = !session.isFavorite;
      videoSessions[index] = session; // trigger update
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
