import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselItem {
  final String title;
  final String subtitle;

  const CarouselItem({required this.title, required this.subtitle});
}

class IntroductionController extends GetxController {
  final PageController pageController = PageController();
  final PageController imagePageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<Map<String, String>> items = [
    {
      "title": "Your Personalized Mental Wellness Companion",
      "subtitle":
          "Discover personalized mental health plans tailored just for you by our AI. Track your mood and explore a world of wellness resources.",
    },
    {
      "title": "Dive and Explore Your Path to Wellness",
      "subtitle":
          "Explore meditation exercises, breathing techniques, articles, courses, journals, and mindfulness resources to find your center.",
    },
    {
      "title": "Gain Insights and Track Progress Overtime",
      "subtitle":
          "Gain valuable insights into your well-being with mood tracking, growth area reports, and life balance graphs overtime.",
    },
  ];

  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (pageController.hasClients) {
        int nextPage = (currentIndex.value + 1) % items.length;

        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    if (imagePageController.hasClients) {
      imagePageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    imagePageController.dispose();
    super.onClose();
  }
}
