import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:Mentora/presentation/onboarding/controllers/onboarding.controller.dart';

class HomeController extends GetxController {
  // Check-in history
  final RxList<DateTime> checkInDates = <DateTime>[].obs;
  final RxList<String> checkInMoods = <String>[].obs;
  final RxInt streakCount = 0.obs;
  final RxInt weeklyCheckInCount = 0.obs;
  final RxString latestMood = ''.obs;

  // Trusted Contact Info
  final RxString trustedContactName = 'Emma (Sister)'.obs;
  final RxString trustedContactPhone = '+1 (555) 019-2834'.obs;

  final RxList<PlanModel> plans = <PlanModel>[].obs;

  void updateTrustedContact(String name, String phone) {
    trustedContactName.value = name;
    trustedContactPhone.value = phone;
  }

  @override
  void onInit() {
    super.onInit();

    // Pre-populate with some mock check-ins so the chart and streak are populated for the demo,
    // while also handling empty state if history is empty.
    final today = DateTime.now();
    checkInDates.addAll([
      today.subtract(const Duration(days: 4)),
      today.subtract(const Duration(days: 3)),
      today.subtract(const Duration(days: 2)),
      today.subtract(const Duration(days: 1)),
    ]);
    checkInMoods.addAll(["Good", "Normal", "Not Good", "Good"]);

    calculateStreakAndWeekly();
    generateDynamicPlans();
    fetchStreakStats();
  }

  void addMoodCheckin(String mood) {
    latestMood.value = mood;
    final today = DateTime.now();

    // Check if already checked in today
    bool alreadyCheckedIn = checkInDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );

    if (!alreadyCheckedIn) {
      checkInDates.add(today);
      checkInMoods.add(mood);
    } else {
      // Update latest mood for today
      int idx = checkInDates.indexWhere(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
      if (idx != -1) {
        checkInMoods[idx] = mood;
      }
    }

    calculateStreakAndWeekly();
    generateDynamicPlans();
    fetchStreakStats();
  }

  Future<void> fetchStreakStats() async {
    try {
      final response = await AssessmentService.getStreakStats();
      if (response != null && response.data != null) {
        final stats = response.data!;
        streakCount.value = stats.currentStreak;
        weeklyCheckInCount.value = stats.weeklyCheckInCount;
      }
    } catch (e) {
      Get.log("Error fetching streak stats: $e");
    }
  }

  void calculateStreakAndWeekly() {
    if (checkInDates.isEmpty) {
      streakCount.value = 0;
      weeklyCheckInCount.value = 0;
      return;
    }

    // Sort check-in dates
    final sortedDates = List<DateTime>.from(checkInDates);
    sortedDates.sort((a, b) => a.compareTo(b));

    // Calculate Streak
    int currentStreak = 1;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    // Start calculating backward from the latest check-in
    DateTime lastChecked = DateTime(
      sortedDates.last.year,
      sortedDates.last.month,
      sortedDates.last.day,
    );

    // If last check-in is not today or yesterday, streak is broken (0)
    final diffToToday = todayDateOnly.difference(lastChecked).inDays;
    if (diffToToday > 1) {
      currentStreak = 0;
    } else {
      currentStreak = 1;
      // Loop backward to find consecutive days
      for (int i = sortedDates.length - 2; i >= 0; i--) {
        final date = DateTime(
          sortedDates[i].year,
          sortedDates[i].month,
          sortedDates[i].day,
        );
        final diff = lastChecked.difference(date).inDays;
        if (diff == 1) {
          currentStreak++;
          lastChecked = date;
        } else if (diff > 1) {
          break; // Streak broken
        }
      }
    }
    streakCount.value = currentStreak;

    // Calculate weekly completion (unique days in the last 7 days)
    final sevenDaysAgo = todayDateOnly.subtract(const Duration(days: 6));
    final uniqueDaysThisWeek = <String>{};
    for (var date in checkInDates) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isAfter(sevenDaysAgo.subtract(const Duration(seconds: 1))) &&
          dateOnly.isBefore(todayDateOnly.add(const Duration(days: 1)))) {
        uniqueDaysThisWeek.add(
          "${dateOnly.year}-${dateOnly.month}-${dateOnly.day}",
        );
      }
    }
    weeklyCheckInCount.value = uniqueDaysThisWeek.length;
  }

  void togglePlanCompletion(int index) {
    if (index >= 0 && index < plans.length) {
      final plan = plans[index];
      plans[index] = PlanModel(
        title: plan.title,
        label: plan.label,
        caption: plan.caption,
        icon: plan.icon,
        isComplete: !plan.isComplete,
      );
      plans.refresh();
    }
  }

  void generateDynamicPlans() {
    // 1. Get onboarding data
    final onboarding = Get.isRegistered<OnboardingController>()
        ? Get.find<OnboardingController>()
        : Get.put(OnboardingController(), permanent: true);

    List<PlanModel> generated = [];

    // 2. Prioritize task based on mood check-in
    if (latestMood.value == 'Angry' || latestMood.value == 'Not Good') {
      generated.add(
        PlanModel(
          title: "stress",
          label: "SOS Calm Breathing",
          caption: "3 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    } else if (latestMood.value == 'Normal' ||
        latestMood.value == 'Good' ||
        latestMood.value == 'Very Good') {
      generated.add(
        PlanModel(
          title: "goal",
          label: "Write Today's Intentions",
          caption: "4 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    }

    // 3. Add dynamic tasks from onboarding assessment
    final goals = onboarding.selectedMainGoalsList;
    if (goals.contains("Reduce stress") || goals.contains("Manage anxiety")) {
      generated.add(
        PlanModel(
          title: "stress",
          label: "Quick Guided Meditation",
          caption: "5 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    }
    if (goals.contains("Improve sleep quality") ||
        onboarding.selectedSleepQualityStatus.value == "Very Poor" ||
        onboarding.selectedSleepQualityStatus.value == "Poor") {
      generated.add(
        PlanModel(
          title: "sleep",
          label: "Deep Sleep Body Scan",
          caption: "8 min",
          icon: '\u{f186}',
          isComplete: false,
        ),
      );
    }
    if (goals.contains("Improve mood") ||
        goals.contains("Manage depression") ||
        onboarding.selectedHappinessStatus.value == "Very Unhappy" ||
        onboarding.selectedHappinessStatus.value == "Unhappy") {
      generated.add(
        PlanModel(
          title: "mindfulness",
          label: "Three-Step Gratitude Practice",
          caption: "5 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    }
    if (goals.contains("Increase focus & productivity")) {
      generated.add(
        PlanModel(
          title: "focus",
          label: "Focus Block & Mind Clearing",
          caption: "10 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    }

    final issues = onboarding.selectedMentalHealthIssuesCausesList;
    if (issues.contains("Work pressure") ||
        issues.contains("Academic stress") ||
        onboarding.selectedHealthStatus.value == "Almost Daily" ||
        onboarding.selectedHealthStatus.value == "Frequently") {
      generated.add(
        PlanModel(
          title: "stress",
          label: "Progressive Muscle Relaxation",
          caption: "7 min",
          icon: '\u{f800}',
          isComplete: false,
        ),
      );
    }
    if (issues.contains("Relationship problems") ||
        issues.contains("Family conflicts")) {
      generated.add(
        PlanModel(
          title: "mindfulness",
          label: "Loving-Kindness Meditation",
          caption: "6 min",
          icon: '\u{f004}',
          isComplete: false,
        ),
      );
    }

    // 4. Fill in default plans if we have too few
    final defaultPlans = [
      PlanModel(
        title: "Meditation",
        label: "Introduction to Meditation",
        caption: "8 min",
        icon: '\u{f800}',
        isComplete: false,
      ),
      PlanModel(
        title: "Breathing",
        label: "Relax your mind and body",
        caption: "5 min",
        icon: '\u{f800}',
        isComplete: false,
      ),
      PlanModel(
        title: "Gratitude",
        label: "Start your day with positivity",
        caption: "4 min",
        icon: '\u{f800}',
        isComplete: false,
      ),
    ];

    for (var def in defaultPlans) {
      if (generated.length < 5 && !generated.any((p) => p.label == def.label)) {
        generated.add(def);
      }
    }

    plans.assignAll(generated.take(6).toList());
  }
}

class PlanModel {
  final String title;
  final String label;
  final String caption;
  final String icon;
  final bool isComplete;

  PlanModel({
    required this.title,
    required this.label,
    required this.caption,
    required this.icon,
    required this.isComplete,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      title: json['title'] as String,
      label: json['label'] as String,
      caption: json['caption'] as String,
      icon: json['icon'] as String,
      isComplete: json['isComplete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'label': label,
      'caption': caption,
      'icon': icon,
      'isComplete': isComplete,
    };
  }
}
