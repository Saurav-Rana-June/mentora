import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/allSet/all_set.screen.dart';
import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/prepare_plan.controller.dart';

class PreparePlanScreen extends GetView<PreparePlanController> {
  PreparePlanScreen({super.key});

  @override
  final controller = Get.put(PreparePlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s12.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.vertical,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Preparing personalized plan for you",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
              Spacing.s12.h,
              Text(
                "Please wait...",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              Spacing.s32.h,
              Spacing.s32.h,
              Spacing.s32.h,

              Obx(
                () => CustomCircularProgressBar(
                  percentage: controller.progressCount.value / 100,
                  size: Get.height / 4,
                  strokeWidth: 14,
                  backgroundColor: slate[100]!,
                  progressColor: primary,
                  textStyle: h1.copyWith(
                    fontSize: 40,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  onComplete: () {
                    Get.to(
                      () => AllSetScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
              ),
              Spacing.s32.h,
              Spacing.s32.h,
              Spacing.s32.h,

              Text(
                "This will just take a moment. Get ready for an amazing well-being experience.",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
