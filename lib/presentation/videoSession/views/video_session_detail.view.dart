import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/model/video_session.model.dart';
import 'package:Mentora/presentation/videoSession/controllers/video_session.controller.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

class VideoSessionDetailView extends StatefulWidget {
  final VideoSessionModel session;

  const VideoSessionDetailView({
    super.key,
    required this.session,
  });

  @override
  State<VideoSessionDetailView> createState() => _VideoSessionDetailViewState();
}

class _VideoSessionDetailViewState extends State<VideoSessionDetailView> {
  final VideoSessionController controller = Get.find<VideoSessionController>();

  bool isPlaying = false;
  double progressSeconds = 0.0;
  late double totalSeconds;
  Timer? playbackTimer;

  @override
  void initState() {
    super.initState();
    totalSeconds = _parseDuration(widget.session.duration);
  }

  double _parseDuration(String durationStr) {
    // e.g., "10 mins" or "25 mins" -> parse out numbers
    final numberRegExp = RegExp(r'\d+');
    final match = numberRegExp.firstMatch(durationStr);
    if (match != null) {
      final minutes = double.tryParse(match.group(0)!) ?? 10.0;
      return minutes * 60;
    }
    return 600.0; // 10 minutes default
  }

  @override
  void dispose() {
    playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (progressSeconds < totalSeconds) {
              progressSeconds += 1.0;
            } else {
              isPlaying = false;
              progressSeconds = 0.0;
              timer.cancel();
            }
          });
        });
      } else {
        playbackTimer?.cancel();
      }
    });
  }

  void _skipSeconds(double seconds) {
    setState(() {
      progressSeconds = (progressSeconds + seconds).clamp(0.0, totalSeconds);
    });
  }

  String _formatTime(double totalSecondsValue) {
    final int minutes = (totalSecondsValue / 60).floor();
    final int seconds = (totalSecondsValue % 60).floor();
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).cardTheme.color ?? (isDark ? slate[800] : white);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const Center(child: CustomBackButton()),
        title: Text(
          "Session Player",
          style: h2.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            // Find current session state from controller for reactivity
            final currentSession = controller.videoSessions.firstWhere(
              (s) => s.id == widget.session.id,
              orElse: () => widget.session,
            );
            return IconButton(
              icon: Icon(
                currentSession.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: currentSession.isFavorite ? red : Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                controller.toggleFavorite(widget.session.id);
              },
            );
          }),
          Spacing.s12.w,
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s16.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.vertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎥 Video Player Screen Mockup
              Container(
                width: double.infinity,
                height: 220.h,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Backdrop Artwork
                      CachedNetworkImage(
                        imageUrl: widget.session.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: slate[800],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/banner.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Semi-transparent overlay during play state
                      Container(
                        color: Colors.black.withValues(alpha: isPlaying ? 0.2 : 0.4),
                      ),
                      // Dynamic visualizer/indicator when playing
                      if (isPlaying)
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.s8.symmetric.horizontal,
                              vertical: Spacing.s4.symmetric.vertical,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.videocam, color: Colors.white, size: 12),
                                Spacing.s4.w,
                                Text(
                                  "PLAYING",
                                  style: r10.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Central Play/Pause circular button
                      InkWell(
                        onTap: _togglePlayPause,
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          height: 60.h,
                          width: 60.h,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.s16.h,

              // 🎛️ Media Control Dashboard (Slider & Skippers)
              Container(
                padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? slate[700]! : slate[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                        activeTrackColor: primary,
                        inactiveTrackColor: isDark ? slate[700] : slate[200],
                        thumbColor: primary,
                      ),
                      child: Slider(
                        value: progressSeconds,
                        min: 0.0,
                        max: totalSeconds,
                        onChanged: (value) {
                          setState(() {
                            progressSeconds = value;
                          });
                        },
                      ),
                    ),
                    // Timeline Labels
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(progressSeconds),
                            style: r12.copyWith(
                              color: Theme.of(context).textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatTime(totalSeconds),
                            style: r12.copyWith(
                              color: Theme.of(context).textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.s8.h,
                    // Skipping Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10, size: 28.sp, color: primary),
                          onPressed: () => _skipSeconds(-10),
                        ),
                        Spacing.s24.w,
                        InkWell(
                          onTap: _togglePlayPause,
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.s16.symmetric.horizontal,
                              vertical: Spacing.s8.symmetric.vertical,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: primary,
                                  size: 18.sp,
                                ),
                                Spacing.s4.w,
                                Text(
                                  isPlaying ? "Pause" : "Play Session",
                                  style: r12.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacing.s24.w,
                        IconButton(
                          icon: Icon(Icons.forward_10, size: 28.sp, color: primary),
                          onPressed: () => _skipSeconds(10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.s20.h,

              // 🏷️ Category Badge & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s12.symmetric.horizontal,
                      vertical: Spacing.s4.symmetric.horizontal,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.session.category.toUpperCase(),
                      style: r10.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 14.sp,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                      Spacing.s4.w,
                      Text(
                        widget.session.views,
                        style: r12.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.s12.h,
              Text(
                widget.session.title,
                style: h2.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Spacing.s8.h,
              // Author row
              Row(
                children: [
                  Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.session.author.split(' ').last.substring(0, 1).toUpperCase(),
                        style: r14.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Spacing.s8.w,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.session.author,
                        style: r14.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Mental Health Coach",
                        style: r10.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.s16.h,
              const Divider(),
              Spacing.s12.h,

              // 📖 Description
              Text(
                "About Session",
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacing.s8.h,
              Text(
                widget.session.description,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  height: 1.5,
                ),
              ),
              Spacing.s24.h,
            ],
          ),
        ),
      ),
    );
  }
}
