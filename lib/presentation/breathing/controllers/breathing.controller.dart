import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BreathingPattern {
  final String name;
  final String description;
  final int inhale;
  final int holdIn;
  final int exhale;
  final int holdOut;

  const BreathingPattern({
    required this.name,
    required this.description,
    required this.inhale,
    required this.holdIn,
    required this.exhale,
    required this.holdOut,
  });

  int get cycleDuration => inhale + holdIn + exhale + holdOut;
}

class BreathingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  Timer? _timer;

  // Breathing presets
  final List<BreathingPattern> patterns = const [
    BreathingPattern(
      name: "Box Breathing",
      description:
          "Relieve stress, clear your mind, and improve focus under pressure.",
      inhale: 4,
      holdIn: 4,
      exhale: 4,
      holdOut: 4,
    ),
    BreathingPattern(
      name: "4-7-8 Relax",
      description:
          "Deep relaxation to help ease anxiety and transition into deep sleep.",
      inhale: 4,
      holdIn: 7,
      exhale: 8,
      holdOut: 0,
    ),
    BreathingPattern(
      name: "Equal Breathing",
      description:
          "Balance your nervous system and bring immediate clarity and calm.",
      inhale: 4,
      holdIn: 0,
      exhale: 4,
      holdOut: 0,
    ),
    BreathingPattern(
      name: "Resonant Breath",
      description:
          "Synchronizes heart and respiratory rate to optimize recovery and calm.",
      inhale: 5,
      holdIn: 0,
      exhale: 5,
      holdOut: 0,
    ),
  ];

  // Reactive states
  final RxInt selectedPatternIndex = 0.obs;
  final RxInt selectedDurationSeconds = 120.obs; // Default 2 minutes
  final RxInt remainingSessionSeconds = 120.obs;
  final RxInt remainingPhaseSeconds = 0.obs;
  final RxString currentPhase = "Ready".obs; // Ready, Inhale, Hold In, Exhale, Hold Out, Completed
  final RxBool isPlaying = false.obs;
  final RxBool isPaused = false.obs;
  final RxBool isCompleted = false.obs;

  BreathingPattern get activePattern => patterns[selectedPatternIndex.value];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.15,
      upperBound: 1.0,
      value: 0.15,
    );
  }

  void startSession() {
    if (isCompleted.value) {
      resetSession();
    }
    isPlaying.value = true;
    isPaused.value = false;
    isCompleted.value = false;

    // If starting fresh
    if (currentPhase.value == "Ready" || currentPhase.value == "Completed") {
      _startNextPhase(startCycle: true);
    } else {
      // Resume current phase animation
      _resumeAnimation();
    }

    _startTimer();
  }

  void pauseSession() {
    isPaused.value = true;
    _stopTimer();
    animationController.stop();
  }

  void resetSession() {
    _stopTimer();
    animationController.stop();
    animationController.value = 0.15; // lowerBound
    isPlaying.value = false;
    isPaused.value = false;
    isCompleted.value = false;
    currentPhase.value = "Ready";
    remainingSessionSeconds.value = selectedDurationSeconds.value;
    remainingPhaseSeconds.value = 0;
  }

  void selectPattern(int index) {
    if (selectedPatternIndex.value == index) return;
    selectedPatternIndex.value = index;
    resetSession();
  }

  void selectDuration(int seconds) {
    if (selectedDurationSeconds.value == seconds) return;
    selectedDurationSeconds.value = seconds;
    resetSession();
  }

  void _startNextPhase({bool startCycle = false}) {
    final pattern = activePattern;

    if (startCycle) {
      _transitionToPhase("Inhale", pattern.inhale);
      return;
    }

    switch (currentPhase.value) {
      case "Inhale":
        if (pattern.holdIn > 0) {
          _transitionToPhase("Hold In", pattern.holdIn);
        } else if (pattern.exhale > 0) {
          _transitionToPhase("Exhale", pattern.exhale);
        } else if (pattern.holdOut > 0) {
          _transitionToPhase("Hold Out", pattern.holdOut);
        } else {
          _transitionToPhase("Inhale", pattern.inhale);
        }
        break;
      case "Hold In":
        if (pattern.exhale > 0) {
          _transitionToPhase("Exhale", pattern.exhale);
        } else if (pattern.holdOut > 0) {
          _transitionToPhase("Hold Out", pattern.holdOut);
        } else {
          _transitionToPhase("Inhale", pattern.inhale);
        }
        break;
      case "Exhale":
        if (pattern.holdOut > 0) {
          _transitionToPhase("Hold Out", pattern.holdOut);
        } else {
          _transitionToPhase("Inhale", pattern.inhale);
        }
        break;
      case "Hold Out":
      default:
        _transitionToPhase("Inhale", pattern.inhale);
        break;
    }
  }

  void _transitionToPhase(String phase, int duration) {
    currentPhase.value = phase;
    remainingPhaseSeconds.value = duration;

    // Start animation for the phase
    if (phase == "Inhale") {
      animationController.animateTo(
        1.0,
        duration: Duration(seconds: duration),
        curve: Curves.easeInOut,
      );
    } else if (phase == "Exhale") {
      animationController.animateTo(
        0.15,
        duration: Duration(seconds: duration),
        curve: Curves.easeInOut,
      );
    } else if (phase == "Hold In") {
      animationController.value = 1.0;
    } else if (phase == "Hold Out") {
      animationController.value = 0.15;
    }
  }

  void _resumeAnimation() {
    final phase = currentPhase.value;
    final duration = remainingPhaseSeconds.value;
    if (duration <= 0) return;

    if (phase == "Inhale") {
      animationController.animateTo(
        1.0,
        duration: Duration(seconds: duration),
        curve: Curves.easeInOut,
      );
    } else if (phase == "Exhale") {
      animationController.animateTo(
        0.15,
        duration: Duration(seconds: duration),
        curve: Curves.easeInOut,
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSessionSeconds.value <= 1) {
        remainingSessionSeconds.value = 0;
        _completeSession();
        return;
      }

      remainingSessionSeconds.value--;

      if (remainingPhaseSeconds.value <= 1) {
        _startNextPhase();
      } else {
        remainingPhaseSeconds.value--;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _completeSession() {
    _stopTimer();
    animationController.stop();
    animationController.value = 0.15;
    isPlaying.value = false;
    isPaused.value = false;
    isCompleted.value = true;
    currentPhase.value = "Completed";
    remainingPhaseSeconds.value = 0;
  }

  @override
  void onClose() {
    _stopTimer();
    animationController.dispose();
    super.onClose();
  }
}
