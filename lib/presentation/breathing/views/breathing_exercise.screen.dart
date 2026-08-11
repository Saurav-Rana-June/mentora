import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/buttons/custom_outline_button.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/breathing.controller.dart';

class BreathingExerciseScreen extends GetView<BreathingController> {
  final int patternIndex;

  BreathingExerciseScreen({super.key, required this.patternIndex}) {
    // Set pattern and reset state
    controller.selectPattern(patternIndex);
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getPhaseColor(String phase) {
    switch (phase) {
      case "Inhale":
        return primary;
      case "Hold In":
      case "Hold Out":
        return const Color(0xFFE2C974); // Soothing warm gold
      case "Exhale":
        return const Color(0xFF7CB6C6); // Calm ocean blue
      default:
        return primary;
    }
  }

  String _getPhaseInstruction(String phase) {
    switch (phase) {
      case "Inhale":
        return "Breathe In";
      case "Hold In":
        return "Hold";
      case "Exhale":
        return "Breathe Out";
      case "Hold Out":
        return "Hold";
      case "Ready":
        return "Get Ready";
      case "Completed":
        return "Well Done";
      default:
        return "Relax";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: SafeArea(child: Obx(() => buildBodyContent(context))),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    final patternName = controller.patterns[patternIndex].name;
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const Center(child: CustomBackButton()),
      title: Text(
        patternName,
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBodyContent(BuildContext context) {
    if (controller.isCompleted.value) {
      return buildCompletionView(context);
    }

    if (controller.isPlaying.value) {
      return buildFocusView(context);
    }

    return buildSetupView(context);
  }

  /// SETUP MODE (Before starting the session)
  Widget buildSetupView(BuildContext context) {
    final pattern = controller.activePattern;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.value.w,
          vertical: Spacing.s16.value.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPatternHeaderCard(context, pattern),
            Spacing.s32.h,
            buildDurationSelectorSection(context),
            Spacing.s40.h,
            CustomPrimaryButton(
              text: "Start Session",
              prefixIcon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              onPressed: () => controller.startSession(),
              height: 52.h,
              borderRadius: 26.r,
            ),
            Spacing.s24.h,
          ],
        ),
      ),
    );
  }

  Widget buildPatternHeaderCard(
    BuildContext context,
    BreathingPattern pattern,
  ) {
    return CustomPrimaryCard(
      borderRadius: 20.r,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 60.h,
                width: 60.h,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(pattern.icon, style: TextStyle(fontSize: 30.sp)),
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.name,
                      style: h2.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacing.s4.h,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Cycle: ${pattern.cycleDuration}s",
                        style: r12.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s20.h,
          Text(
            pattern.description,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              height: 1.4,
            ),
          ),
          Spacing.s24.h,
          Text(
            "Technique Rhythm",
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.s12.h,
          buildBreathingPatternTimeline(context, pattern),
        ],
      ),
    );
  }

  Widget buildBreathingPatternTimeline(
    BuildContext context,
    BreathingPattern pattern,
  ) {
    final List<Map<String, dynamic>> phases = [
      {'name': 'Inhale', 'duration': pattern.inhale, 'color': primary},
      if (pattern.holdIn > 0)
        {
          'name': 'Hold',
          'duration': pattern.holdIn,
          'color': const Color(0xFFE2C974),
        },
      {
        'name': 'Exhale',
        'duration': pattern.exhale,
        'color': const Color(0xFF7CB6C6),
      },
      if (pattern.holdOut > 0)
        {
          'name': 'Hold',
          'duration': pattern.holdOut,
          'color': const Color(0xFFE2C974),
        },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: phases.map((phase) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: (phase['color'] as Color).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: (phase['color'] as Color).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "${phase['duration']}s",
                  style: r16.copyWith(
                    color: phase['color'] as Color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  phase['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: r12.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildDurationSelectorSection(BuildContext context) {
    final durations = [
      {'label': '1 Min', 'value': 60},
      {'label': '2 Min', 'value': 120},
      {'label': '5 Min', 'value': 300},
      {'label': '10 Min', 'value': 600},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                size: 18.sp,
                color: primary,
              ),
              Spacing.s4.w,
              Text(
                "Configure Session Duration",
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Spacing.s12.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: durations.map((dur) {
            final isSelected =
                controller.selectedDurationSeconds.value == dur['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDuration(dur['value'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? primary
                          : Theme.of(context).cardTheme.color ??
                                Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      dur['label'] as String,
                      style: r14.copyWith(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// FOCUS MODE (During active exercise playback)
  Widget buildFocusView(BuildContext context) {
    final pattern = controller.activePattern;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s20.value.w,
          vertical: Spacing.s24.value.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Floating Technique capsule
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).cardTheme.color!.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pattern.icon, style: TextStyle(fontSize: 16.sp)),
                  Spacing.s8.w,
                  Text(
                    pattern.name,
                    style: r14.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s32.h,
            buildVisualizerSection(context),
            Spacing.s40.h,
            buildControlsSection(context),
            Spacing.s24.h,
          ],
        ),
      ),
    );
  }

  Widget buildVisualizerSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phase = controller.currentPhase.value;
    final phaseColor = _getPhaseColor(phase);

    final double totalSec = controller.selectedDurationSeconds.value.toDouble();
    final double remainingSec = controller.remainingSessionSeconds.value
        .toDouble();
    final double progress = totalSec > 0
        ? (totalSec - remainingSec) / totalSec
        : 0.0;

    return RepaintBoundary(
      child: Center(
        child: Container(
          height: 310.h,
          width: 310.h,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outermost dial: session progress track
              SizedBox(
                height: 298.h,
                width: 298.h,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5.w,
                  backgroundColor: isDark
                      ? slate[800]!.withValues(alpha: 0.3)
                      : slate[100]!.withValues(alpha: 0.6),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primary.withValues(alpha: 0.8),
                  ),
                ),
              ),

              // Soft shadow visualizer base
              Container(
                height: 270.h,
                width: 270.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? slate[900]!.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.03,
                      ),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              // Concentric animated breathing rings responding to phase and animation scale
              AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  final scale = controller.animationController.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer soft glow ring
                      Container(
                        height: 255.h * scale,
                        width: 255.h * scale,
                        decoration: BoxDecoration(
                          color: phaseColor.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Middle semi-transparent ring
                      Container(
                        height: 205.h * scale,
                        width: 205.h * scale,
                        decoration: BoxDecoration(
                          color: phaseColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: phaseColor.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Core solid visualizer circle
                      Container(
                        height: 145.h * scale,
                        width: 145.h * scale,
                        decoration: BoxDecoration(
                          color: phaseColor.withValues(alpha: 0.82),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: phaseColor.withValues(alpha: 0.35),
                              blurRadius: 18 * scale,
                              spreadRadius: 2 * scale,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Timer values inside centerpiece
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getPhaseInstruction(phase),
                    textAlign: TextAlign.center,
                    style: h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Spacing.s4.h,
                  Obx(() {
                    final seconds = controller.remainingPhaseSeconds.value;
                    if (controller.currentPhase.value == "Ready") {
                      return Icon(
                        Icons.keyboard_double_arrow_up_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 28.sp,
                      );
                    }
                    return Text(
                      "${seconds}s",
                      style: h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 34.sp,
                      ),
                    );
                  }),
                  Spacing.s8.h,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        Spacing.s4.w,
                        Text(
                          _formatDuration(remainingSec.toInt()),
                          style: r12.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildControlsSection(BuildContext context) {
    final isPaused = controller.isPaused.value;
    final phase = controller.currentPhase.value;
    final phaseColor = _getPhaseColor(phase);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        Container(
          height: 52.h,
          width: 52.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => controller.resetSession(),
            icon: Icon(Icons.replay_rounded, color: primary, size: 24.sp),
            tooltip: "Reset Session",
          ),
        ),
        Spacing.s24.w,

        // Play / Pause Central Button
        GestureDetector(
          onTap: isPaused
              ? () => controller.startSession()
              : () => controller.pauseSession(),
          child: Container(
            height: 76.h,
            width: 76.h,
            decoration: BoxDecoration(
              color: phaseColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: phaseColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: Colors.white,
              size: 38.sp,
            ),
          ),
        ),
        Spacing.s24.w,

        // Stop / Exit Button
        Container(
          height: 52.h,
          width: 52.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => controller.resetSession(),
            icon: Icon(Icons.close_rounded, color: red, size: 24.sp),
            tooltip: "Stop & Exit",
          ),
        ),
      ],
    );
  }

  /// COMPLETION VIEW (After completing the full session duration)
  Widget buildCompletionView(BuildContext context) {
    final pattern = controller.activePattern;
    final durationText = _formatDuration(
      controller.selectedDurationSeconds.value,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Elegant pulsing check circle container
          Container(
            height: 120.h,
            width: 120.h,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: 90.h,
                width: 90.h,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: primary,
                  size: 56.sp,
                ),
              ),
            ),
          ),
          Spacing.s32.h,
          Text(
            "Session Completed!",
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s12.h,
          Text(
            "Wonderful job. You completed $durationText of ${pattern.name}.",
            textAlign: TextAlign.center,
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              height: 1.4,
            ),
          ),
          Spacing.s40.h,
          CustomPrimaryButton(
            text: "Do it again",
            onPressed: () => controller.startSession(),
            height: 52.h,
            borderRadius: 26.r,
          ),
          Spacing.s16.h,
          CustomOutlineButton(
            label: "Back to Techniques",
            onTap: () => Get.back(),
            height: 52.h,
            borderRadius: 26.r,
            borderColor: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            textColor: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ],
      ),
    );
  }
}
