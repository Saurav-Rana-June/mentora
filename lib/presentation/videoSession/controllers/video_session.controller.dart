import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/model/video_session.model.dart';

class VideoSessionController extends GetxController {
  final videoSessions = <VideoSessionModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final searchController = TextEditingController();

  final categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    final mockSessions = [
      VideoSessionModel(
        id: 1,
        title: "10-Minute Morning Yoga Flow for Beginners",
        category: "Stress Management",
        duration: "10 mins",
        imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=400&q=80",
        author: "Coach Jessica",
        description: "Wake up your body and mind with this gentle 10-minute morning yoga flow. Perfect for beginners to build flexibility, strength, and morning mindfulness.",
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        views: "1.2K views",
      ),
      VideoSessionModel(
        id: 2,
        title: "Deep Sleep Guided Visualization & Breathing",
        category: "Sleep Science",
        duration: "25 mins",
        imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=400&q=80",
        author: "Dr. Sarah Cole",
        description: "Release the tension of the day and prepare for a deep, restful sleep. Join Dr. Sarah Cole in this guided visualization and slow breathing practice designed for deep relaxation.",
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        views: "850 views",
      ),
      VideoSessionModel(
        id: 3,
        title: "Mindfulness for Anxious Moments",
        category: "Anxiety Relief",
        duration: "15 mins",
        imageUrl: "https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=400&q=80",
        author: "Lama Yeshe",
        description: "Learn to ground yourself when anxiety strikes. This session teaches practical breathing and grounding techniques to calm your nervous system instantly.",
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        views: "2.4K views",
      ),
      VideoSessionModel(
        id: 4,
        title: "Stretching & Breathwork for Focus",
        category: "Focus Work",
        duration: "12 mins",
        imageUrl: "https://images.unsplash.com/photo-1512438248247-f0f2a5a8b7f0?auto=format&fit=crop&w=400&q=80",
        author: "Coach Mark",
        description: "Re-energize your brain during a work break. A combination of quick physical stretches and hyper-focused breathing to increase blood flow and mental clarity.",
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        views: "530 views",
      ),
      VideoSessionModel(
        id: 5,
        title: "Emotional Balance & Self-Compassion",
        category: "Mood Booster",
        duration: "18 mins",
        imageUrl: "https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=400&q=80",
        author: "Dr. Elena Rostova",
        description: "A nurturing session focused on cultivating kindness towards yourself. Ideal for times of self-doubt or high emotional distress.",
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        views: "920 views",
      ),
    ];

    videoSessions.assignAll(mockSessions);

    // Extract unique categories
    final uniqueCats = <String>{};
    for (var session in mockSessions) {
      uniqueCats.add(session.category);
    }
    categories.assignAll(['All', ...uniqueCats]);
  }

  List<VideoSessionModel> get filteredSessions {
    return videoSessions.where((session) {
      final matchesCategory = selectedCategory.value == 'All' ||
          session.category.toLowerCase() == selectedCategory.value.toLowerCase();

      final query = searchQuery.value.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
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

