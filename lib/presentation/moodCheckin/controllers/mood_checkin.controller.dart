import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/theme.dart';

class MoodCheckinController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString selectedMood = 'Angry'.obs;
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

  RxList<MoodReason> selectedMoodReasonsList = <MoodReason>[].obs;
  RxList<MoodReason> selectedExtactReasonsList = <MoodReason>[].obs;

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
