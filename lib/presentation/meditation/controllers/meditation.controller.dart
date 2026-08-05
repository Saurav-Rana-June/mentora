import 'dart:async';
import 'package:get/get.dart';
import '../widgets/meditation_session.dart';

class MeditationController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxSet<String> favoritedIds = {'1', '3'}.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate initial loading time for visual skeleton demonstration
    Timer(const Duration(milliseconds: 700), () {
      isLoading.value = false;
    });
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

  // Filter list of sessions based on category and query search matching
  List<MeditationSession> get filteredSessions {
    return mockMeditationSessions.where((session) {
      final matchesCategory = selectedCategory.value == 'All' ||
          session.category.toLowerCase() == selectedCategory.value.toLowerCase();
      final matchesQuery = searchQuery.value.isEmpty ||
          session.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          session.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // Filter list of featured sessions
  List<MeditationSession> get featuredSessions {
    return mockMeditationSessions.where((session) {
      if (!session.isFeatured) return false;
      final matchesCategory = selectedCategory.value == 'All' ||
          session.category.toLowerCase() == selectedCategory.value.toLowerCase();
      final matchesQuery = searchQuery.value.isEmpty ||
          session.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }
}
