import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import '../../widgets/meditation_session.dart';

class MeditationPlayerController extends GetxController {
  late MeditationSession session;
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs; // Start at 0% progress
  final RxBool isFavorited = false.obs;
  final RxBool isLoading = false.obs;
  final RxString displayDuration = ''.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SoundcloudClient _soundcloudClient = SoundcloudClient();
  
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void onInit() {
    super.onInit();
    // Resolve arguments from GetX or fallback to first mock session
    session = Get.arguments as MeditationSession? ?? mockMeditationSessions.first;
    // Set initial favorite status
    isFavorited.value = session.id == '1' || session.id == '3';
    displayDuration.value = session.duration;

    _initAudio();
  }

  Future<void> _initAudio() async {
    isLoading.value = true;
    try {
      final track = await _soundcloudClient.tracks.getByUrl(
        session.soundTrack
      );
      final streams = await _soundcloudClient.tracks.getStreams(track.id);
      if (streams.isNotEmpty) {
        final stream = streams.firstWhere(
          (s) => s.container == 'mp3',
          orElse: () => streams.first,
        );
        final streamUrl = stream.url;
        
        await _audioPlayer.setUrl(streamUrl);
        
        _positionSubscription = _audioPlayer.positionStream.listen((pos) {
          final dur = _audioPlayer.duration ?? Duration.zero;
          if (dur.inSeconds > 0) {
            progress.value = pos.inSeconds / dur.inSeconds;
          }
        });
        
        _durationSubscription = _audioPlayer.durationStream.listen((dur) {
          if (dur != null && dur.inSeconds > 0) {
            final minutes = dur.inMinutes;
            displayDuration.value = '$minutes min';
          }
        });
        
        _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
          isPlaying.value = state.playing;
          if (state.processingState == ProcessingState.completed) {
            isPlaying.value = false;
            progress.value = 0.0;
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.pause();
          }
        });
      }
    } catch (e) {
      // Silently catch or log
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  // Toggle playback status
  void togglePlayPause() {
    if (isLoading.value) return;
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  // Toggle favorite status
  void toggleFavorite() {
    isFavorited.value = !isFavorited.value;
  }

  // Update slider progress position manually
  void updateProgress(double value) {
    if (isLoading.value) return;
    progress.value = value;
    final dur = _audioPlayer.duration;
    if (dur != null) {
      final seekPos = Duration(milliseconds: (value * dur.inMilliseconds).round());
      _audioPlayer.seek(seekPos);
    }
  }

  // Restart progress to beginning of track
  void seekToBeginning() {
    if (isLoading.value) return;
    progress.value = 0.0;
    _audioPlayer.seek(Duration.zero);
  }
}
