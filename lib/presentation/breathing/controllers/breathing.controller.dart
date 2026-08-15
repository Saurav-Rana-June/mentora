import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/dal/services/breathing_service.dart';
import 'package:Mentora/data/model/breathing_pattern.model.dart';

class BreathingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  Timer? _timer;

  // Cache keys constants
  static const String _patternsCacheKey = StorageKeys.BREATHING_PATTERNS;
  static const String _patternsLastUpdatedCacheKey = StorageKeys.BREATHING_PATTERNS_LAST_UPDATED;

  // Dynamic presets list loaded from cache/API
  final RxList<BreathingPatternModel> patterns = <BreathingPatternModel>[].obs;
  final RxBool isLoading = true.obs;

  // Reactive states
  final RxInt selectedPatternIndex = 0.obs;
  final RxInt selectedDurationSeconds = 120.obs; // Default 2 minutes
  final RxInt remainingSessionSeconds = 120.obs;
  final RxInt remainingPhaseSeconds = 0.obs;
  final RxString currentPhase =
      "Ready".obs; // Ready, Inhale, Hold In, Exhale, Hold Out, Completed
  final RxBool isPlaying = false.obs;
  final RxBool isPaused = false.obs;
  final RxBool isCompleted = false.obs;

  BreathingPatternModel get activePattern {
    if (patterns.isNotEmpty) {
      return patterns[selectedPatternIndex.value];
    }
    return BreathingPatternModel(
      name: "Loading...",
      description: "Loading breathing presets...",
      inhale: 4,
      holdIn: 4,
      exhale: 4,
      holdOut: 4,
      icon: "🌬️",
    );
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.15,
      upperBound: 1.0,
      value: 0.15,
    );
    fetchPatterns();
  }

  /// Fetch breathing patterns from cache first, then API (using timestamp verification)
  Future<void> fetchPatterns({bool forceRefresh = false}) async {
    try {
      // 1. Try loading from local storage cache
      final List<dynamic>? cachedPatterns = StorageUtils.read<List<dynamic>>(_patternsCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_patternsLastUpdatedCacheKey);

      bool hasCache = false;
      if (cachedPatterns != null && cachedPatterns.isNotEmpty && cachedLastUpdated != null) {
        final List<BreathingPatternModel> loaded = cachedPatterns
            .map((e) => BreathingPatternModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        patterns.assignAll(loaded);
        hasCache = true;
      }

      isLoading.value = !hasCache;

      bool needFetch = !hasCache || forceRefresh;

      // Check lastUpdated on the server
      if (hasCache && !forceRefresh) {
        final checkRes = await BreathingService.getBreathingPatterns(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final DateTime? cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            needFetch = false;
          }
        }
      }

      if (!needFetch) {
        isLoading.value = false;
        return;
      }

      // 2. Fetch fresh patterns from the API
      final res = await BreathingService.getBreathingPatterns();
      if (res != null && res.data != null) {
        patterns.assignAll(res.data!);
        
        // Update local cache
        final serialized = res.data!.map((e) => e.toJson()).toList();
        await StorageUtils.write(_patternsCacheKey, serialized);
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            _patternsLastUpdatedCacheKey,
            res.lastUpdated!.toIso8601String(),
          );
        }
      }
      isLoading.value = false;
    } catch (e) {
      Get.log("Failed to fetch breathing patterns: $e");
      isLoading.value = false;
    }
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
    final inhale = pattern.inhale ?? 4;
    final holdIn = pattern.holdIn ?? 0;
    final exhale = pattern.exhale ?? 4;
    final holdOut = pattern.holdOut ?? 0;

    if (startCycle) {
      _transitionToPhase("Inhale", inhale);
      return;
    }

    switch (currentPhase.value) {
      case "Inhale":
        if (holdIn > 0) {
          _transitionToPhase("Hold In", holdIn);
        } else if (exhale > 0) {
          _transitionToPhase("Exhale", exhale);
        } else if (holdOut > 0) {
          _transitionToPhase("Hold Out", holdOut);
        } else {
          _transitionToPhase("Inhale", inhale);
        }
        break;
      case "Hold In":
        if (exhale > 0) {
          _transitionToPhase("Exhale", exhale);
        } else if (holdOut > 0) {
          _transitionToPhase("Hold Out", holdOut);
        } else {
          _transitionToPhase("Inhale", inhale);
        }
        break;
      case "Exhale":
        if (holdOut > 0) {
          _transitionToPhase("Hold Out", holdOut);
        } else {
          _transitionToPhase("Inhale", inhale);
        }
        break;
      case "Hold Out":
      default:
        _transitionToPhase("Inhale", inhale);
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
