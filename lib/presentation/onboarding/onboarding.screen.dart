import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/onboarding/views/age.view.dart';
import 'package:Mentora/presentation/onboarding/views/gender.view.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.linear.progress.bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/onboarding.controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  OnboardingScreen({super.key});

  @override
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: Column(
        children: [
          Obx(() => Expanded(child: controller.getCurrentView())),

          buildButton(),
        ],
      ),
    );
  }

  Padding buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
      child: CustomPrimaryButton(
        text: "Continue",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: controller.continueClicked,
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) => AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBackButton(),
        Spacing.s32.w,

        Obx(
          () => Expanded(
            child: CustomLinearProgressBar(
              progress: controller.currentStep.value / 10,
              height: 10,
              backgroundColor: Theme.of(
                context,
              ).sliderTheme.inactiveTrackColor!,
              progressColor: primary,
              borderRadius: BorderRadius.circular(20),
              animate: true,
            ),
          ),
        ),
        Spacing.s32.w,

        Obx(
          () => Text(
            "${controller.currentStep.value} / 10",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    surfaceTintColor: Colors.transparent,
  );
}
