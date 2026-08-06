import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

class MusicPlayerController extends GetxController {
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs; // 0.0 to 1.0
  final RxBool isLoading = false.obs;
  final RxString displayDuration = ''.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SoundcloudClient _soundcloudClient = SoundcloudClient();

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;

  bool _isInitRun = false;

  void initialize({required String audioUrl, required String initialDuration}) {
    if (_isInitRun) return;
    _isInitRun = true;
    displayDuration.value = initialDuration;
    _initAudio(audioUrl);
  }

  Future<void> _initAudio(String audioUrl) async {
    isLoading.value = true;
    try {
      String resolvedUrl = audioUrl;
      // If it is a SoundCloud URL, resolve it dynamically
      if (audioUrl.contains('soundcloud.com')) {
        final track = await _soundcloudClient.tracks.getByUrl(audioUrl);
        final streams = await _soundcloudClient.tracks.getStreams(track.id);
        if (streams.isNotEmpty) {
          final stream = streams.firstWhere(
            (s) => s.container == 'mp3',
            orElse: () => streams.first,
          );
          resolvedUrl = stream.url;
        }
      }

      await _audioPlayer.setUrl(resolvedUrl);

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
    } catch (e) {
      // Silently catch or handle error
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

  void togglePlayPause() {
    if (isLoading.value) return;
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void updateProgress(double value) {
    if (isLoading.value) return;
    progress.value = value;
    final dur = _audioPlayer.duration;
    if (dur != null) {
      final seekPos = Duration(milliseconds: (value * dur.inMilliseconds).round());
      _audioPlayer.seek(seekPos);
    }
  }

  void seekToBeginning() {
    if (isLoading.value) return;
    progress.value = 0.0;
    _audioPlayer.seek(Duration.zero);
  }
}
