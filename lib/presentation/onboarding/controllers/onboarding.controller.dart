import 'package:Mentora/presentation/onboarding/views/age.view.dart';
import 'package:Mentora/presentation/onboarding/views/eat_healthy.view.dart';
import 'package:Mentora/presentation/onboarding/views/gender.view.dart';
import 'package:Mentora/presentation/onboarding/views/happiness.view.dart';
import 'package:Mentora/presentation/onboarding/views/health_issues.dart';
import 'package:Mentora/presentation/onboarding/views/main_goal.view.dart';
import 'package:Mentora/presentation/onboarding/views/meditation.view.dart';
import 'package:Mentora/presentation/onboarding/views/name.view.dart';
import 'package:Mentora/presentation/onboarding/views/sleep_quality.view.dart';
import 'package:Mentora/presentation/onboarding/views/status_update.view.dart';
import 'package:Mentora/presentation/preparePlan/prepare_plan.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt currentStep = 1.obs;
  RxInt maxStep = 10.obs;
  RxInt selectedAge = 23.obs;
  RxBool selectedGenderIsMale = true.obs;

  RxString selectedHealthStatus = ''.obs;
  RxString selectedEatingHealthyStatus = ''.obs;
  RxString selectedMeditationStatus = ''.obs;
  RxString selectedSleepQualityStatus = ''.obs;
  RxString selectedHappinessStatus = ''.obs;

  RxList<String> selectedMainGoalsList = <String>[].obs;
  RxList<String> selectedMentalHealthIssuesCausesList = <String>[].obs;

  RxList<String> mainGoalsList = <String>[
    "Reduce stress",
    "Manage anxiety",
    "Improve mood",
    "Build self-confidence",
    "Improve sleep quality",
    "Manage depression",
    "Control overthinking",
    "Increase focus & productivity",
    "Develop healthy habits",
    "Improve emotional balance",
    "Build resilience",
    "Practice mindfulness",
    "Improve self-care",
    "Boost motivation",
    "Improve relationships",
    "Manage anger",
    "Increase positivity",
    "Feel more present",
    "Heal from past experiences",
    "Find inner peace",
  ].obs;

  RxList<String> mentalHealthIssuesCausesList = <String>[
    "Relationship problems",
    "Financial stress",
    "Work pressure",
    "Academic stress",
    "Family conflicts",
    "Childhood trauma",
    "Past emotional abuse",
    "Grief and loss",
    "Loneliness",
    "Social isolation",
    "Low self-esteem",
    "Chronic stress",
    "Unresolved past experiences",
    "Unhealthy lifestyle",
    "Lack of sleep",
    "Poor work-life balance",
    "Fear of failure",
    "Overthinking habits",
    "Negative self-talk",
    "Lack of emotional support",
    "Major life changes",
    "Health issues",
    "Addiction or substance use",
    "Comparison with others",
    "Uncertainty about the future",
  ].obs;

  RxList<String> healthStatusList = <String>[
    "Almost Daily",
    "Frequently",
    "Occasionally",
    "Rarely",
    "Never",
  ].obs;

  RxList<String> eatingHealthyStatusList = <String>[
    "Almost Daily",
    "Frequently",
    "Occasionally",
    "Rarely",
    "Never",
  ].obs;

  RxList<String> meditationStatusList = <String>[
    "Yes, regularly",
    "Yes, occasionally",
    "Yes, a long time ago",
    "No, I have tried",
  ].obs;

  RxList<String> sleepQualityStatusList = <String>[
    "Very Poor",
    "Poor",
    "Average",
    "Good",
    "Excellent",
  ].obs;

  RxList<String> happinessStatusList = <String>[
    "Very Unhappy",
    "Unhappy",
    "Neutal",
    "Happy",
    "Very Happy",
  ].obs;

  void continueClicked() {
    if (currentStep.value < maxStep.value) {
      currentStep.value = currentStep.value + 1;
    } else {
      Get.to(() => PreparePlanScreen(), transition: Transition.rightToLeft);
    }
  }

  Widget getCurrentView() {
    switch (currentStep.value) {
      case 1:
        return NameView();
      case 2:
        return GenderView();
      case 3:
        return AgeView();
      case 4:
        return MainGoalView();
      case 5:
        return HealthIssuesView();
      case 6:
        return StatusUpdateView();
      case 7:
        return EatHealthyView();
      case 8:
        return MeditationView();
      case 9:
        return SleepQualityView();
      case 10:
        return HappinessView();
      default:
        return SizedBox();
    }
  }
}
