import 'package:Mentora/presentation/onboarding/controllers/onboarding.controller.dart';
import 'package:Mentora/widgets/others/custom.scroll.selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';

class AgeView extends StatelessWidget {
  AgeView({super.key});

  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          Text(
            "How old are you?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Text(
            "Your age help us to tailor various our recommendations to you.",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          Spacing.s32.h,

          Obx(
            () => CustomScrollSelector(
              minValue: 1,
              maxValue: 100,
              initialValue: controller.selectedAge.value,
              unit: 'years',
              onChanged: (age) {
                controller.selectedAge.value = age;
              },
              height: Get.height / 1.8,
              selectedTextStyle: h1.copyWith(color: primary),
              unselectedTextStyle: r16.copyWith(),
              dividerColor: primary,
            ),
          ),
        ],
      ),
    );
  }
}
