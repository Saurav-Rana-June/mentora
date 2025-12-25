import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/theme.dart';

class MoodCheckinController extends GetxController {
  RxString selectedMood = 'Angry'.obs;
  final segments = [
    GaugeSegment(red, "assets/moods/Angry Face.svg", "Angry"),
    GaugeSegment(orange, "assets/moods/Not Good Face.svg", "Not Good"),
    GaugeSegment(grey, "assets/moods/Normal Face.svg", "Normal"),
    GaugeSegment(lightGreen, "assets/moods/Happy Face.svg", "Good"),
    GaugeSegment(darkGreen, "assets/moods/Very Happy Face.svg", "Very Good"),
  ];

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

class GaugeSegment {
  final Color color;
  final String icon;
  final String label;

  GaugeSegment(this.color, this.icon, this.label);
}
