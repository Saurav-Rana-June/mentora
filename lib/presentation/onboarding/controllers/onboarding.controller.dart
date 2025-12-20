import 'package:Mentora/presentation/onboarding/views/age.view.dart';
import 'package:Mentora/presentation/onboarding/views/gender.view.dart';
import 'package:Mentora/presentation/onboarding/views/main_goal.view.dart';
import 'package:Mentora/presentation/onboarding/views/name.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt currentStep = 1.obs;
  RxInt maxStep = 10.obs;
  RxInt selectedAge = 23.obs;
  RxBool selectedGenderIsMale = true.obs;

  RxList<String> selectedMainGoalsList = <String>[].obs;

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

  void continueClicked() {
    if (currentStep.value < maxStep.value) {
      currentStep.value = currentStep.value + 1;
    } else {
      print('Max Reached!!');
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
      default:
        return SizedBox();
    }
  }
}
