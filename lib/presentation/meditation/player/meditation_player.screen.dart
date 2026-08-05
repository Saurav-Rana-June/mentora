import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

import '../widgets/meditation_session.dart';
import 'widgets/player_artwork.dart';
import 'widgets/player_progress_bar.dart';
import 'widgets/player_controls.dart';
import 'widgets/player_bottom_actions.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationSession? session;

  const MeditationPlayerScreen({
    super.key,
    this.session,
  });

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  late MeditationSession _session;
  bool _isPlaying = false;
  double _progress = 0.35; // Start at 35% progress
  bool _isFavorited = false;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    // Resolve arguments from GetX or use the constructor parameter or a default fallback
    _session = widget.session ?? Get.arguments as MeditationSession? ?? mockMeditationSessions.first;
    // Set initial favorite status
    _isFavorited = _session.id == '1' || _session.id == '3';
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  // Toggle playback timer
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  // Start dummy timer to increment progress
  void _startTimer() {
    _stopTimer();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.002; // Increment slightly
        if (_progress >= 1.0) {
          _progress = 0.0;
          _isPlaying = false;
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  // Toggle favorite
  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Soothing ambient gradient
    final gradientColors = isDark
        ? [
            const Color(0xFF1E2820),
            const Color(0xFF273129),
            Theme.of(context).scaffoldBackgroundColor,
          ]
        : [
            const Color(0xFFEDF6F0),
            const Color(0xFFF5FAF7),
            Theme.of(context).scaffoldBackgroundColor,
          ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s16.value.w,
                  vertical: Spacing.s8.value.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      "Now Playing",
                      style: r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Text(
                        _isFavorited ? '\u{f004}' : '\u{f004}', // heart icon
                        style: TextStyle(
                          fontFamily: _isFavorited ? 'FontAwesomeSolid' : 'FontAwesomeLight',
                          fontSize: 20.sp,
                          color: _isFavorited ? red : Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),

              // Artwork & Text Info
              PlayerArtwork(session: _session),
              const Spacer(flex: 2),

              // Progress Bar
              PlayerProgressBar(
                progress: _progress,
                totalDurationString: _session.duration,
                onChanged: (val) {
                  setState(() {
                    _progress = val;
                  });
                },
              ),
              Spacing.s16.h,

              // Playback Controls
              PlayerControls(
                isPlaying: _isPlaying,
                onPlayPauseTap: _togglePlayPause,
                onPreviousTap: () {
                  setState(() {
                    _progress = 0.0;
                  });
                },
                onNextTap: () {
                  setState(() {
                    _progress = 0.0;
                  });
                },
              ),
              const Spacer(flex: 2),

              // Bottom Panel Utility Actions
              PlayerBottomActions(
                isFavorited: _isFavorited,
                onFavoriteTap: _toggleFavorite,
              ),
              Spacing.s16.h,
            ],
          ),
        ),
      ),
    );
  }
}
