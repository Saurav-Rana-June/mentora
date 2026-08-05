import 'dart:async';
import 'package:get/get.dart';
import '../../widgets/meditation_session.dart';

class MeditationPlayerController extends GetxController {
  late MeditationSession session;
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.35.obs; // Start at 35% progress
  final RxBool isFavorited = false.obs;
  Timer? _playbackTimer;

  @override
  void onInit() {
    super.onInit();
    // Resolve arguments from GetX or fallback to first mock session
    session = Get.arguments as MeditationSession? ?? mockMeditationSessions.first;
    // Set initial favorite status
    isFavorited.value = session.id == '1' || session.id == '3';
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  // Toggle playback status and control simulated tick timer
  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  // Toggle favorite status
  void toggleFavorite() {
    isFavorited.value = !isFavorited.value;
  }

  // Update slider progress position manually
  void updateProgress(double value) {
    progress.value = value;
  }

  // Restart progress to simulated beginning of track
  void seekToBeginning() {
    progress.value = 0.0;
  }

  // Start dummy timer to increment progress reactively
  void _startTimer() {
    _stopTimer();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      progress.value += 0.002;
      if (progress.value >= 1.0) {
        progress.value = 0.0;
        isPlaying.value = false;
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }
}
