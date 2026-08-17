import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/model/video_session.model.dart';
import '../../../infrastructure/dal/services/video_session_service.dart';

class VideoSessionController extends GetxController {
  final videoSessions = <VideoSessionModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final searchController = TextEditingController();

  final categories = <String>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch of filters and sessions from API
    Future.wait([fetchFilters(), fetchSessions()]);
  }

  /// Fetch filters/categories dynamically from the backend
  Future<void> fetchFilters() async {
    try {
      final res = await VideoSessionService.getVideoSessionFilters();
      if (res != null && res.data != null && res.data!.isNotEmpty) {
        categories.assignAll(res.data!);
      }
    } catch (e) {
      Get.log("Failed to load video session filters from API: $e");
    }
  }

  /// Fetch video sessions from the backend
  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      final res = await VideoSessionService.getVideoSessions();
      if (res != null && res.data != null) {
        videoSessions.assignAll(res.data!);
      }
    } catch (e) {
      Get.log("Failed to load video sessions from API: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<VideoSessionModel> get filteredSessions {
    return videoSessions.where((session) {
      final matchesCategory =
          selectedCategory.value == 'All' ||
          session.category.toLowerCase() ==
              selectedCategory.value.toLowerCase();

      final query = searchQuery.value.toLowerCase().trim();
      final matchesSearch =
          query.isEmpty ||
          session.title.toLowerCase().contains(query) ||
          session.category.toLowerCase().contains(query) ||
          session.author.toLowerCase().contains(query) ||
          session.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

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
