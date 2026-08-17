import 'dart:async';
import 'dart:math' as math;
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

  const VideoSessionDetailView({super.key, required this.session});

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
    final numberRegExp = RegExp(r'\d+');
    final match = numberRegExp.firstMatch(durationStr);
    if (match != null) {
      final minutes = double.tryParse(match.group(0)!) ?? 10.0;
      return minutes * 60;
    }
    return 600.0;
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
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
          final currentSession = controller.videoSessions.firstWhere(
            (s) => s.id == widget.session.id,
            orElse: () => widget.session,
          );
          return Container(
            margin: EdgeInsets.only(right: Spacing.s12.value.w),
            decoration: BoxDecoration(
              color: isDark
                  ? slate[800]!.withValues(alpha: 0.5)
                  : white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                currentSession.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: currentSession.isFavorite
                    ? red
                    : Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                controller.toggleFavorite(widget.session.id);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.value.w,
          vertical: Spacing.s12.value.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoPlayer(context),
            Spacing.s20.h,
            _buildMediaControls(context),
            Spacing.s20.h,
            _buildMetadata(context),
            Spacing.s12.h,
            Text(
              widget.session.title,
              style: h1.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            Spacing.s16.h,
            _buildAuthorCard(context),
            Spacing.s20.h,
            const Divider(),
            Spacing.s16.h,
            _buildAboutSession(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.session.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: slate[800],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/banner.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: isPlaying ? 0.3 : 0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s12.value.w,
                  vertical: Spacing.s4.value.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AudioVisualizer(isPlaying: isPlaying),
                    Spacing.s8.w,
                    Text(
                      isPlaying ? "PLAYING" : "PAUSED",
                      style: r10.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _togglePlayPause,
              borderRadius: BorderRadius.circular(40.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 70.h,
                width: 70.h,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isPlaying ? 0.85 : 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: isPlaying ? 0.3 : 0.6),
                      blurRadius: isPlaying ? 25 : 15,
                      spreadRadius: isPlaying ? 4 : 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaControls(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        Theme.of(context).cardTheme.color ?? (isDark ? slate[800]! : white);
    final borderColor = isDark ? slate[700]! : slate[200]!;

    return Container(
      padding: EdgeInsets.all(Spacing.s16.value.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3.h,
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
          Spacing.s16.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speed Selector Mock
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? slate[700]!.withValues(alpha: 0.3)
                        : slate[100]!,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "1.0x",
                    style: r12.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Skip Back 10s
              IconButton(
                icon: Icon(
                  Icons.replay_10_rounded,
                  size: 26.sp,
                  color: isDark ? white : slate[600],
                ),
                onPressed: () => _skipSeconds(-10),
              ),
              // Play/Pause Action Circle
              InkWell(
                onTap: _togglePlayPause,
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  height: 56.h,
                  width: 56.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primary,
                        primary.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
              // Skip Forward 10s
              IconButton(
                icon: Icon(
                  Icons.forward_10_rounded,
                  size: 26.sp,
                  color: isDark ? white : slate[600],
                ),
                onPressed: () => _skipSeconds(10),
              ),
              // Sleep Timer Mock
              IconButton(
                icon: Icon(
                  Icons.timer_outlined,
                  size: 22.sp,
                  color: primary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s12.value.w,
            vertical: Spacing.s4.value.h,
          ),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            widget.session.category.toUpperCase(),
            style: r10.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.remove_red_eye_outlined,
              size: 16.sp,
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
    );
  }

  Widget _buildAuthorCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        Theme.of(context).cardTheme.color ?? (isDark ? slate[800]! : white);
    final borderColor = isDark ? slate[700]! : slate[200]!;

    return Container(
      padding: EdgeInsets.all(Spacing.s12.value.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            height: 44.h,
            width: 44.h,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                widget.session.author
                    .split(' ')
                    .last
                    .substring(0, 1)
                    .toUpperCase(),
                style: r16.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Spacing.s12.w,
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
              Spacing.s4.h,
              Text(
                "Mindfulness & Wellness Expert",
                style: r10.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSession(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            height: 1.6,
          ),
        ),
        Spacing.s24.h,
      ],
    );
  }
}

class _AudioVisualizer extends StatefulWidget {
  final bool isPlaying;
  const _AudioVisualizer({required this.isPlaying});

  @override
  State<_AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<_AudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double factor;
            switch (index) {
              case 0:
                factor =
                    0.3 +
                    0.7 *
                        (0.5 +
                            0.5 * (math.sin(_controller.value * 2 * math.pi)));
                break;
              case 1:
                factor =
                    0.2 +
                    0.8 *
                        (0.5 +
                            0.5 *
                                (math.cos(
                                  _controller.value * 2 * math.pi + 1.0,
                                )));
                break;
              case 2:
                factor =
                    0.4 +
                    0.6 *
                        (0.5 +
                            0.5 *
                                (math.sin(
                                  _controller.value * 2 * math.pi + 2.0,
                                )));
                break;
              default:
                factor =
                    0.1 +
                    0.9 *
                        (0.5 +
                            0.5 *
                                (math.cos(
                                  _controller.value * 2 * math.pi + 3.0,
                                )));
                break;
            }
            if (!widget.isPlaying) factor = 0.15;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              width: 3.w,
              height: (16.h * factor).clamp(3.h, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            );
          },
        );
      }),
    );
  }
}
