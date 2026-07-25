import 'package:get/get.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';

class InsightsController extends GetxController {
  final RxInt selectedGrowthTab = 0.obs;
  final RxInt selectedMoodTab = 0.obs;

  void toggleGrowthTab(int index) {
    selectedGrowthTab.value = index;
  }

  void toggleMoodTab(int index) {
    selectedMoodTab.value = index;
  }

  // Getters for computing statistics from HomeController check-in data
  String getDominantMood(HomeController homeController) {
    if (homeController.checkInMoods.isEmpty) return 'No data yet';
    final Map<String, int> frequencies = {};
    for (var mood in homeController.checkInMoods) {
      frequencies[mood] = (frequencies[mood] ?? 0) + 1;
    }
    String dominant = '';
    int maxCount = 0;
    frequencies.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominant = mood;
      }
    });
    return dominant;
  }

  double getCheckInConsistency(HomeController homeController) {
    if (homeController.checkInDates.isEmpty) return 0.0;
    // Calculate ratio of checked-in days out of last 7 days
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    int checkedInCount = 0;
    for (var date in homeController.checkInDates) {
      if (date.isAfter(sevenDaysAgo)) {
        checkedInCount++;
      }
    }
    return checkedInCount / 7.0;
  }
}
