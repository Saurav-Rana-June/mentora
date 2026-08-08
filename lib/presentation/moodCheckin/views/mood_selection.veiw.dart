import 'package:Mentora/data/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/others/custom.rating.gauage.dart';
import 'package:Mentora/presentation/moodCheckin/controllers/mood_checkin.controller.dart';

class MoodSelectionView extends GetView<MoodCheckinController> {
  const MoodSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s12.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How do you feel Today?",
              textAlign: TextAlign.center,
              style: h2.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.headlineMedium!.color,
              ),
            ),
            Spacing.s24.h,
            Spacing.s24.h,
            Obx(
              () => SvgPicture.asset(
                AppUtils.getMoodImage(controller.selectedMood.value),
                width: 150,
                height: 150,
              ),
            ),
            Spacing.s24.h,
            Obx(
              () => Text(
                controller.selectedMood.value,
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
            ),
            Spacing.s40.h,
            Spacing.s40.h,
            RatingGauge(
              segments: controller.segments,
              onSelect: (value) {
                controller.selectedMood.value = value.label;
              },
            ),
          ],
        ),
      ),
    );
  }
}
