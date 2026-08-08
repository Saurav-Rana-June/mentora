import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

import 'controllers/music_player.controller.dart';
import 'widgets/music_player_artwork.dart';
import 'widgets/music_player_progress_bar.dart';
import 'widgets/music_player_controls.dart';

class MusicPlayerView extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final String duration;
  
  // Customization & Overrides
  final RxBool? isFavorited;
  final VoidCallback? onFavoriteTap;
  final List<Color>? gradientColors;
  final Widget? customTopBar;
  final Widget? customArtwork;
  final Widget? customProgress;
  final Widget? customControls;

  const MusicPlayerView({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.duration,
    this.isFavorited,
    this.onFavoriteTap,
    this.gradientColors,
    this.customTopBar,
    this.customArtwork,
    this.customProgress,
    this.customControls,
  });

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  late final MusicPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MusicPlayerController(), tag: widget.audioUrl);
    controller.initialize(
      audioUrl: widget.audioUrl,
      initialDuration: widget.duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default soothing ambient gradient if none specified
    final defaultGradientColors = isDark
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

    final colors = widget.gradientColors ?? defaultGradientColors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar Header
              widget.customTopBar ?? _buildDefaultTopBar(context),
              const Spacer(flex: 1),

              // Artwork & Content Labels
              widget.customArtwork ?? _buildDefaultArtwork(context),
              const Spacer(flex: 2),

              // Progress slider
              widget.customProgress ?? _buildDefaultProgress(context),
              Spacing.s16.h,

              // Playback controls
              widget.customControls ?? _buildDefaultControls(context),
              const Spacer(flex: 2),

              Spacing.s16.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultTopBar(BuildContext context) {
    return Padding(
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
          if (widget.isFavorited != null)
            Obx(
              () => IconButton(
                onPressed: widget.onFavoriteTap,
                icon: Text(
                  widget.isFavorited!.value ? '\u{f004}' : '\u{f004}',
                  style: TextStyle(
                    fontFamily: widget.isFavorited!.value
                        ? 'FontAwesomeSolid'
                        : 'FontAwesomeLight',
                    fontSize: 20.sp,
                    color: widget.isFavorited!.value
                        ? red
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            )
          else
            SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildDefaultArtwork(BuildContext context) {
    return MusicPlayerArtwork(
      title: widget.title,
      subtitle: widget.category,
      imageUrl: widget.imageUrl,
      description: widget.description,
    );
  }

  Widget _buildDefaultProgress(BuildContext context) {
    return Obx(
      () => MusicPlayerProgressBar(
        progress: controller.progress.value,
        totalDurationString: controller.displayDuration.value,
        onChanged: (val) => controller.updateProgress(val),
      ),
    );
  }

  Widget _buildDefaultControls(BuildContext context) {
    return Obx(
      () => MusicPlayerControls(
        isPlaying: controller.isPlaying.value,
        isLoading: controller.isLoading.value,
        onPlayPauseTap: () => controller.togglePlayPause(),
        onPreviousTap: () => controller.seekToBeginning(),
        onNextTap: () => controller.seekToBeginning(),
      ),
    );
  }
}
