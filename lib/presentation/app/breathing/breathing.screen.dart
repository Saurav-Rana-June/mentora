import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';

import 'controllers/breathing.controller.dart';
import 'package:Mentora/data/model/breathing_pattern.model.dart';
import 'views/breathing_exercise.screen.dart';
import 'widgets/breathing_content_loading.dart';

class BreathingScreen extends GetView<BreathingController> {
  BreathingScreen({super.key});

  @override
  final controller = Get.put(BreathingController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Breathing",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.value.w,
          vertical: Spacing.s16.value.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildPatternSelector(context)],
        ),
      ),
    );
  }

  Widget buildPatternSelector(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const BreathingContentLoading();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.patterns.length,
        itemBuilder: (context, index) {
          final pattern = controller.patterns[index];
          return buildBreathingPatternTile(
            context,
            index: index,
            pattern: pattern,
          );
        },
      );
    });
  }

  Widget buildBreathingPatternTile(
    BuildContext context, {
    required int index,
    required BreathingPatternModel pattern,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Spacing.s16.value.h),
      child: InkWell(
        onTap: () {
          Get.to(
            () => BreathingExerciseScreen(patternIndex: index),
            transition: Transition.rightToLeft,
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: CustomPrimaryCard(
          borderRadius: 16.r,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Circular Emoji Icon Container
              Container(
                height: 56.h,
                width: 56.h,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(pattern.icon ?? '🌬️', style: TextStyle(fontSize: 26.sp)),
                ),
              ),
              Spacing.s16.w,
              // Right Content Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            pattern.name ?? '',
                            style: r18.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacing.s8.w,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "${pattern.cycleDuration}s",
                            style: r12.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacing.s4.h,
                    Text(
                      pattern.description ?? '',
                      style: r14.copyWith(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                    Spacing.s12.h,
                    buildBreathingPatternTimeline(context, pattern),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBreathingPatternTimeline(
    BuildContext context,
    BreathingPatternModel pattern,
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

    chips.add(buildItem("${pattern.inhale ?? 4}s", "Inhale"));
    if ((pattern.holdIn ?? 0) > 0) {
      chips.add(buildItem("${pattern.holdIn ?? 0}s", "Hold"));
    }
    chips.add(buildItem("${pattern.exhale ?? 4}s", "Exhale"));
    if ((pattern.holdOut ?? 0) > 0) {
      chips.add(buildItem("${pattern.holdOut ?? 0}s", "Hold"));
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
}
