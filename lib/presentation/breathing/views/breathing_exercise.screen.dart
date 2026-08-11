import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    final patternName = controller.patterns[patternIndex].name;
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
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

  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isCompleted.value) {
        return buildCompletionView(context);
      }

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s16.value.w,
            vertical: Spacing.s24.value.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildVisualizerSection(context),
              Spacing.s32.h,
              buildControlsSection(context),
              Spacing.s32.h,
              if (!controller.isPlaying.value) ...[
                buildDurationSelector(context),
              ] else ...[
                buildPatternInfoCard(context),
              ],
              Spacing.s32.h,
            ],
          ),
        ),
      );
    });
  }

  Widget buildVisualizerSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        height: 280.h,
        width: 280.h,
        decoration: BoxDecoration(
          color: isDark
              ? slate[900]!.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Concentric animated breathing rings
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                final scale = controller.animationController.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer soft glow ring
                    Container(
                      height: 260.h * scale,
                      width: 260.h * scale,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Middle semi-transparent ring
                    Container(
                      height: 210.h * scale,
                      width: 210.h * scale,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Core solid visualizer circle
                    Container(
                      height: 150.h * scale,
                      width: 150.h * scale,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.4),
                            blurRadius: 15 * scale,
                            spreadRadius: 2 * scale,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Text values inside the centerpiece
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final phase = controller.currentPhase.value;
                  return Text(
                    phase == "Ready" ? "Ready" : phase.toUpperCase(),
                    style: h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  );
                }),
                Spacing.s4.h,
                Obx(() {
                  final seconds = controller.remainingPhaseSeconds.value;
                  if (controller.currentPhase.value == "Ready") {
                    return Text(
                      "Start",
                      style: r14.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return Text(
                    "${seconds}s",
                    style: h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 36.sp,
                    ),
                  );
                }),
                Spacing.s8.h,
                Obx(() {
                  final remaining = controller.remainingSessionSeconds.value;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _formatDuration(remaining),
                      style: r12.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildControlsSection(BuildContext context) {
    final isPlaying = controller.isPlaying.value;
    final isPaused = controller.isPaused.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isPlaying)
          ElevatedButton.icon(
            onPressed: () => controller.startSession(),
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            label: Text(
              "Start Session",
              style: r16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 4,
            ),
          )
        else ...[
          // Reset Button
          OutlinedButton.icon(
            onPressed: () => controller.resetSession(),
            icon: Icon(Icons.replay_rounded, color: primary),
            label: Text(
              "Reset",
              style: r16.copyWith(color: primary, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primary, width: 2),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
          Spacing.s16.w,
          // Play / Pause Toggle Button
          ElevatedButton.icon(
            onPressed: isPaused
                ? () => controller.startSession()
                : () => controller.pauseSession(),
            icon: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: Colors.white,
            ),
            label: Text(
              isPaused ? "Resume" : "Pause",
              style: r16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 3,
            ),
          ),
        ],
      ],
    );
  }

  Widget buildDurationSelector(BuildContext context) {
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
          child: Text(
            "Select Duration",
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? primary : Theme.of(context).cardColor,
                      width: 1.5,
                    ),
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

  Widget buildPatternInfoCard(BuildContext context) {
    final pattern = controller.activePattern;
    return CustomPrimaryCard(
      borderRadius: 16.r,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Technique: ${pattern.name}",
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.s8.h,
          Text(
            pattern.description,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
              fontWeight: FontWeight.w400,
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
    final List<Widget> chips = [];

    Widget buildItem(String duration, String name) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            duration,
            style: r14.copyWith(color: primary, fontWeight: FontWeight.w700),
          ),
          Text(
            " $name",
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    chips.add(buildItem("${pattern.inhale}s", "Inhale"));
    if (pattern.holdIn > 0) {
      chips.add(buildItem("${pattern.holdIn}s", "Hold"));
    }
    chips.add(buildItem("${pattern.exhale}s", "Exhale"));
    if (pattern.holdOut > 0) {
      chips.add(buildItem("${pattern.holdOut}s", "Hold"));
    }

    final List<Widget> wrappedChildren = [];
    for (int i = 0; i < chips.length; i++) {
      wrappedChildren.add(chips[i]);
      if (i < chips.length - 1) {
        wrappedChildren.add(
          Text(
            "·",
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: wrappedChildren,
    );
  }

  Widget buildCompletionView(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: primary,
              size: 60.sp,
            ),
          ),
          Spacing.s24.h,
          Text(
            "Session Completed!",
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s12.h,
          Text(
            "Wonderful job. You completed ${_formatDuration(controller.selectedDurationSeconds.value)} of ${controller.activePattern.name}.",
            textAlign: TextAlign.center,
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              height: 1.4,
            ),
          ),
          Spacing.s32.h,
          ElevatedButton(
            onPressed: () => controller.resetSession(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 2,
            ),
            child: Text(
              "Do it again",
              style: r16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.s12.h,
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Back to Techniques",
              style: r16.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
