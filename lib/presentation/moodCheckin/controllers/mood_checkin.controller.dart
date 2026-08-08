import 'package:Mentora/controllers/global.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/infrastructure/dal/services/assessment_service.dart';
import 'package:Mentora/data/model/assessment/daily_mood_assessment.model.dart';
import '../../../infrastructure/theme/theme.dart';

class MoodCheckinController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  RxInt currentIndex = 0.obs;
  RxString selectedMood = 'Angry'.obs;
  RxBool isUpdateMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if we passed a DailyMoodAssessmentModel to update
    if (Get.arguments != null && Get.arguments is DailyMoodAssessmentModel) {
      final argument = Get.arguments as DailyMoodAssessmentModel;
      isUpdateMode.value = true;

      // Pre-fill selected mood
      selectedMood.value = argument.feeling ?? 'Angry';

      // Pre-fill reasons
      selectedMoodReasonsList.clear();
      for (var label in argument.why ?? []) {
        final match = moodReasonsList.firstWhereOrNull((r) => r.label == label);
        if (match != null) {
          selectedMoodReasonsList.add(match);
        }
      }

      // Pre-fill exact feelings
      selectedExtactReasonsList.clear();
      for (var label in argument.exactFeeling ?? []) {
        final match = exactReasonsList.firstWhereOrNull(
          (r) => r.label == label,
        );
        if (match != null) {
          selectedExtactReasonsList.add(match);
        }
      }

      // Pre-fill notes
      notesController.text = argument.notes ?? "";
    }
  }

  final segments = [
    GaugeSegment(red, "assets/moods/Angry Face.svg", "Angry"),
    GaugeSegment(orange, "assets/moods/Not Good Face.svg", "Not Good"),
    GaugeSegment(grey, "assets/moods/Normal Face.svg", "Normal"),
    GaugeSegment(lightGreen, "assets/moods/Happy Face.svg", "Good"),
    GaugeSegment(darkGreen, "assets/moods/Very Happy Face.svg", "Very Good"),
  ];

  RxList<MoodReason> moodReasonsList = <MoodReason>[
    MoodReason('💼', 'Work'),
    MoodReason('🎓', 'School'),
    MoodReason('👨‍👩‍👧‍👦', 'Family'),
    MoodReason('💑', 'Partner'),
    MoodReason('🏥', 'Health'),
    MoodReason('🧑‍🤝‍🧑', 'Friends'),
    MoodReason('🌦️', 'Weather'),
    MoodReason('🎨', 'Hobbies'),
    MoodReason('💰', 'Finances'),
    MoodReason('🎉', 'Events'),
    MoodReason('🏋️‍♂️', 'Exercise'),
    MoodReason('✈️', 'Travel'),
    MoodReason('🌳', 'Nature'),
    MoodReason('😴', 'Sleep'),
    MoodReason('😣', 'Stress'),
    MoodReason('⏰', 'Time Pressure'),
    MoodReason('📚', 'Deadlines'),
    MoodReason('💸', 'Money Worries'),
    MoodReason('💔', 'Relationship'),
    MoodReason('🤒', 'Illness'),
    MoodReason('😴', 'Sleep'),
    MoodReason('📱', 'Overthinking'),
    MoodReason('🚦', 'Traffic'),
    MoodReason('🧠', 'Mental Load'),
  ].obs;

  RxList<MoodReason> exactReasonsList = <MoodReason>[
    MoodReason('😄', 'Happy'),
    MoodReason('😊', 'Calm'),
    MoodReason('😌', 'Relaxed'),
    MoodReason('😁', 'Excited'),
    MoodReason('🥰', 'Content'),
    MoodReason('🙏', 'Grateful'),

    MoodReason('😣', 'Stressed'),
    MoodReason('😰', 'Anxious'),
    MoodReason('😓', 'Overwhelmed'),
    MoodReason('😤', 'Frustrated'),
    MoodReason('😠', 'Angry'),

    MoodReason('😔', 'Sad'),
    MoodReason('😞', 'Disappointed'),
    MoodReason('🥺', 'Lonely'),
    MoodReason('😢', 'Hurt'),

    MoodReason('😴', 'Tired'),
    MoodReason('🥱', 'Exhausted'),
    MoodReason('😐', 'Numb'),
    MoodReason('🤯', 'Mentally Drained'),

    MoodReason('💪', 'Motivated'),
    MoodReason('🧠', 'Focused'),
    MoodReason('✨', 'Inspired'),
  ].obs;

  TextEditingController notesController = TextEditingController();

  RxList<MoodReason> selectedMoodReasonsList = <MoodReason>[].obs;
  RxList<MoodReason> selectedExtactReasonsList = <MoodReason>[].obs;

  void toggleMoodReason(MoodReason reason) {
    final exists = selectedMoodReasonsList.any((m) => m.label == reason.label);

    if (exists) {
      selectedMoodReasonsList.removeWhere((m) => m.label == reason.label);
    } else {
      selectedMoodReasonsList.add(reason);
    }
  }

  void toggleExtactReason(MoodReason reason) {
    final exists = selectedExtactReasonsList.any(
      (m) => m.label == reason.label,
    );

    if (exists) {
      selectedExtactReasonsList.removeWhere((m) => m.label == reason.label);
    } else {
      selectedExtactReasonsList.add(reason);
    }
  }

  RxBool isLoading = false.obs;

  Future<bool> saveCheckIn() async {
    isLoading.value = true;
    try {
      final feeling = selectedMood.value;
      final why = selectedMoodReasonsList.map((e) => e.label).toList();
      final exactFeeling = selectedExtactReasonsList
          .map((e) => e.label)
          .toList();
      final notes = notesController.text.trim();

      final response = isUpdateMode.value
          ? await AssessmentService.updateDailyMood(
              feeling: feeling,
              why: why.isNotEmpty ? why : null,
              exactFeeling: exactFeeling.isNotEmpty ? exactFeeling : null,
              notes: notes.isNotEmpty ? notes : null,
            )
          : await AssessmentService.createOrUpdateDailyMood(
              feeling: feeling,
              why: why.isNotEmpty ? why : null,
              exactFeeling: exactFeeling.isNotEmpty ? exactFeeling : null,
              notes: notes.isNotEmpty ? notes : null,
            );

      if (response != null && response.data != null) {
        return true;
      }
    } catch (e) {
      Get.log("Error saving daily mood check-in: $e");
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}

class GaugeSegment {
  final Color color;
  final String icon;
  final String label;

  GaugeSegment(this.color, this.icon, this.label);
}

class MoodReason {
  final String icon;
  final String label;

  MoodReason(this.icon, this.label);
}
