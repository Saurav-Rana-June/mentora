import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<PlanModel> plans = [
    PlanModel(
      title: "Meditation",
      label: "Introduction to Meditation",
      caption: "8 mins",
      icon: '\u{f800}',
      isComplete: true,
    ),
    PlanModel(
      title: "Deep Breathing",
      label: "Relax your mind and body",
      caption: "5 mins",
      icon: '\u{f800}',
      isComplete: true,
    ),
    PlanModel(
      title: "Morning Gratitude",
      label: "Start your day with positivity",
      caption: "4 mins",
      icon: '\u{f800}',
      isComplete: true,
    ),
    PlanModel(
      title: "Mindful Walking",
      label: "Be present while you move",
      caption: "10 mins",
      icon: '\u{f800}',
      isComplete: true,
    ),
    PlanModel(
      title: "Body Scan",
      label: "Release physical tension",
      caption: "7 mins",
      icon: '\u{f800}',
      isComplete: false,
    ),
    PlanModel(
      title: "Journaling",
      label: "Write your thoughts and feelings",
      caption: "6 mins",
      icon: '\u{f800}',
      isComplete: false,
    ),
    PlanModel(
      title: "Positive Affirmations",
      label: "Build self-confidence",
      caption: "3 mins",
      icon: '\u{f800}',
      isComplete: false,
    ),
    PlanModel(
      title: "Evening Reflection",
      label: "Calm your mind before sleep",
      caption: "5 mins",
      icon: '\u{f800}',
      isComplete: false,
    ),
  ].obs;
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
