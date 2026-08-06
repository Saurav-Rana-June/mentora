import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

import 'controllers/meditation_player.controller.dart';
import 'widgets/player_artwork.dart';
import 'widgets/player_progress_bar.dart';
import 'widgets/player_controls.dart';
import 'widgets/player_bottom_actions.dart';

class MeditationPlayerScreen extends GetView<MeditationPlayerController> {
  MeditationPlayerScreen({super.key});

  @override
  final controller = Get.put(MeditationPlayerController());

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
              // Top Bar Header
              _buildTopBar(context),
              const Spacer(flex: 1),

              // Artwork & Content Labels
              _buildArtwork(context),
              const Spacer(flex: 2),

              // Progress slider
              _buildProgress(context),
              Spacing.s16.h,

              // Playback controls
              _buildControls(context),
              const Spacer(flex: 2),

              Spacing.s16.h,
            ],
          ),
        ),
      ),
    );
  }

  // Decompose Top Bar Header UI to private builder
  Widget _buildTopBar(BuildContext context) {
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
          Obx(
            () => IconButton(
              onPressed: () => controller.toggleFavorite(),
              icon: Text(
                controller.isFavorited.value ? '\u{f004}' : '\u{f004}',
                style: TextStyle(
                  fontFamily: controller.isFavorited.value
                      ? 'FontAwesomeSolid'
                      : 'FontAwesomeLight',
                  fontSize: 20.sp,
                  color: controller.isFavorited.value
                      ? red
                      : Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Decompose Artwork UI to private builder
  Widget _buildArtwork(BuildContext context) {
    return PlayerArtwork(session: controller.session);
  }

  // Decompose Progress slider UI to private builder
  Widget _buildProgress(BuildContext context) {
    return Obx(
      () => PlayerProgressBar(
        progress: controller.progress.value,
        totalDurationString: controller.displayDuration.value,
        onChanged: (val) => controller.updateProgress(val),
      ),
    );
  }

  // Decompose Playback controls UI to private builder
  Widget _buildControls(BuildContext context) {
    return Obx(
      () => PlayerControls(
        isPlaying: controller.isPlaying.value,
        isLoading: controller.isLoading.value,
        onPlayPauseTap: () => controller.togglePlayPause(),
        onPreviousTap: () => controller.seekToBeginning(),
        onNextTap: () => controller.seekToBeginning(),
      ),
    );
  }

  // Decompose Bottom actions UI to private builder
  Widget _buildBottomActions(BuildContext context) {
    return Obx(
      () => PlayerBottomActions(
        isFavorited: controller.isFavorited.value,
        onFavoriteTap: () => controller.toggleFavorite(),
      ),
    );
  }
}
