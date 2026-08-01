import 'package:get/get.dart';
import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:Mentora/data/model/assessment/daily_mood_assessment.model.dart';
import 'package:Mentora/presentation/onboarding/controllers/onboarding.controller.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/model/tasks/plan.model.dart';
import 'package:Mentora/infrastructure/dal/services/tasks_service.dart';
import 'package:Mentora/data/methods/app_method.dart';

class HomeController extends GetxController {
  // Check-in history
  final RxList<DateTime> checkInDates = <DateTime>[].obs;
  final RxList<String> checkInMoods = <String>[].obs;
  final RxList<DailyMoodAssessmentModel> moodHistoryList =
      <DailyMoodAssessmentModel>[].obs;
  final RxInt streakCount = 0.obs;
  final RxInt weeklyCheckInCount = 0.obs;
  final RxString latestMood = ''.obs;
  final Rx<DailyMoodAssessmentModel?> todayCheckIn =
      Rx<DailyMoodAssessmentModel?>(null);

  // Trusted Contact Info
  final RxString trustedContactName = ''.obs;
  final RxString trustedContactPhone = ''.obs;

  final RxList<PlanModel> plans = <PlanModel>[].obs;
  final RxBool isLoadingPlans = false.obs;

  void updateTrustedContact(String name, String phone) {
    trustedContactName.value = name;
    trustedContactPhone.value = phone;
    AppMethod.saveTrustedContact(name, phone);
  }

  @override
  void onInit() {
    super.onInit();

    // Load trusted contact info from storage (with defaults if empty)
    trustedContactName.value =
        AppMethod.getTrustedContactName() ?? 'Emma (Sister)';
    trustedContactPhone.value =
        AppMethod.getTrustedContactPhone() ?? '+1 (555) 019-2834';

    calculateStreakAndWeekly();
    generateDynamicPlans();
    fetchStreakStats();
    fetchMoodHistory();
    fetchDailyPlan();
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
    fetchMoodHistory();
  }

  Future<void> fetchStreakStats() async {
    try {
      final response = await AssessmentService.getStreakStats();
      if (response != null && response.data != null) {
        final stats = response.data!;
        streakCount.value = stats.currentStreak ?? 0;
        weeklyCheckInCount.value = stats.weeklyCheckInCount ?? 0;
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

  Future<void> fetchDailyPlan() async {
    try {
      isLoadingPlans.value = true;
      final response = await TasksService.getDailyPlan(timezone: 'UTC');
      if (response != null && response.data != null) {
        plans.assignAll(response.data!);
      }
    } catch (e) {
      Get.log("Error fetching daily plan: $e");
    } finally {
      isLoadingPlans.value = false;
    }
  }

  Future<void> togglePlanCompletion(int index) async {
    if (index >= 0 && index < plans.length) {
      final plan = plans[index];
      final newStatus = !plan.isComplete;

      // Optimistically update UI
      final updatedPlan = PlanModel(
        id: plan.id,
        activityId: plan.activityId,
        title: plan.title,
        caption: plan.caption,
        icon: plan.icon,
        duration: plan.duration,
        category: plan.category,
        sortOrder: plan.sortOrder,
        isComplete: newStatus,
      );
      plans[index] = updatedPlan;
      plans.refresh();

      try {
        final response = await TasksService.updatePlanItemCompletion(
          planItemId: plan.id,
          isComplete: newStatus,
        );
        if (response != null && response.data != null) {
          plans[index] = response.data!;
          plans.refresh();
        }
      } catch (e) {
        Get.log("Error updating plan item status: $e");
        // Revert back on error
        plans[index] = plan;
        plans.refresh();
      }
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
          id: -1,
          activityId: -1,
          title: "SOS Calm Breathing",
          caption: "Calming breaths",
          duration: "3 min",
          category: "stress",
          icon: 'breathing',
          sortOrder: 1,
          isComplete: false,
        ),
      );
    } else if (latestMood.value == 'Normal' ||
        latestMood.value == 'Good' ||
        latestMood.value == 'Very Good') {
      generated.add(
        PlanModel(
          id: -1,
          activityId: -1,
          title: "Write Today's Intentions",
          caption: "Write intentions",
          duration: "4 min",
          category: "goal",
          icon: 'lotus',
          sortOrder: 1,
          isComplete: false,
        ),
      );
    }

    // 3. Add dynamic tasks from onboarding assessment
    final goals = onboarding.selectedMainGoalsList;
    if (goals.contains("Reduce stress") || goals.contains("Manage anxiety")) {
      generated.add(
        PlanModel(
          id: -1,
          activityId: -1,
          title: "Quick Guided Meditation",
          caption: "Guided meditation",
          duration: "5 min",
          category: "stress",
          icon: 'lotus',
          sortOrder: 2,
          isComplete: false,
        ),
      );
    }
    if (goals.contains("Improve sleep quality") ||
        onboarding.selectedSleepQualityStatus.value == "Very Poor" ||
        onboarding.selectedSleepQualityStatus.value == "Poor") {
      generated.add(
        PlanModel(
          id: -1,
          activityId: -1,
          title: "Deep Sleep Body Scan",
          caption: "Body scan",
          duration: "8 min",
          category: "sleep",
          icon: 'sleep',
          sortOrder: 3,
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
          id: -1,
          activityId: -1,
          title: "Three-Step Gratitude Practice",
          caption: "Gratitude practice",
          duration: "5 min",
          category: "mindfulness",
          icon: 'heart',
          sortOrder: 4,
          isComplete: false,
        ),
      );
    }
    if (goals.contains("Increase focus & productivity")) {
      generated.add(
        PlanModel(
          id: -1,
          activityId: -1,
          title: "Focus Block & Mind Clearing",
          caption: "Mind clearing",
          duration: "10 min",
          category: "focus",
          icon: 'lotus',
          sortOrder: 5,
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
          id: -1,
          activityId: -1,
          title: "Progressive Muscle Relaxation",
          caption: "Muscle relaxation",
          duration: "7 min",
          category: "stress",
          icon: 'lotus',
          sortOrder: 6,
          isComplete: false,
        ),
      );
    }
    if (issues.contains("Relationship problems") ||
        issues.contains("Family conflicts")) {
      generated.add(
        PlanModel(
          id: -1,
          activityId: -1,
          title: "Loving-Kindness Meditation",
          caption: "Loving-kindness",
          duration: "6 min",
          category: "mindfulness",
          icon: 'heart',
          sortOrder: 7,
          isComplete: false,
        ),
      );
    }

    // 4. Fill in default plans if we have too few
    final defaultPlans = [
      PlanModel(
        id: -1,
        activityId: -1,
        title: "Introduction to Meditation",
        caption: "Intro to meditation",
        duration: "8 min",
        category: "Meditation",
        icon: 'lotus',
        sortOrder: 8,
        isComplete: false,
      ),
      PlanModel(
        id: -1,
        activityId: -1,
        title: "Relax your mind and body",
        caption: "Mind and body",
        duration: "5 min",
        category: "Breathing",
        icon: 'lotus',
        sortOrder: 9,
        isComplete: false,
      ),
      PlanModel(
        id: -1,
        activityId: -1,
        title: "Start your day with positivity",
        caption: "Positivity",
        duration: "4 min",
        category: "Gratitude",
        icon: 'lotus',
        sortOrder: 10,
        isComplete: false,
      ),
    ];

    for (var def in defaultPlans) {
      if (generated.length < 5 && !generated.any((p) => p.title == def.title)) {
        generated.add(def);
      }
    }

    plans.assignAll(generated.take(6).toList());
  }

  Future<void> fetchMoodHistory() async {
    try {
      final response = await AssessmentService.getDailyMoods();
      if (response != null && response.data != null) {
        final List<DailyMoodAssessmentModel> history = response.data!;

        moodHistoryList.assignAll(history);

        checkInDates.clear();
        checkInMoods.clear();

        final today = DateTime.now();
        DailyMoodAssessmentModel? foundToday;

        for (var checkIn in history) {
          final DateTime? checkInDate = checkIn.createdAt != null
              ? DateTime.tryParse(checkIn.createdAt!)?.toLocal()
              : null;
          if (checkInDate != null) {
            checkInDates.add(checkInDate);
            checkInMoods.add(checkIn.feeling ?? '');

            if (checkInDate.year == today.year &&
                checkInDate.month == today.month &&
                checkInDate.day == today.day) {
              foundToday = checkIn;
            }
          }
        }

        todayCheckIn.value = foundToday;
        if (foundToday != null) {
          latestMood.value = foundToday.feeling ?? '';
        }

        calculateStreakAndWeekly();
        fetchDailyPlan();

        if (Get.isRegistered<GlobalController>()) {
          Get.find<GlobalController>().fetchMoodTrackerStats();
        }
      }
    } catch (e) {
      Get.log("Error fetching mood history: $e");
    }
  }

  String moodImage(String selectedMood) {
    switch (selectedMood) {
      case 'Angry':
        return "assets/moods/Angry Face.svg";
      case 'Not Good':
        return "assets/moods/Not Good Face.svg";
      case 'Normal':
        return "assets/moods/Normal Face.svg";
      case 'Good':
        return "assets/moods/Happy Face.svg";
      case 'Very Good':
        return "assets/moods/Very Happy Face.svg";
      default:
        return "";
    }
  }
}
