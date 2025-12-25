import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.rating.gauage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/mood_checkin.controller.dart';

class MoodCheckinScreen extends GetView<MoodCheckinController> {
  const MoodCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: SafeArea(
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
                  controller.moodImage(controller.selectedMood.value),
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
      ),
      bottomNavigationBar: Obx(() => buildButton()),
    );
  }

  Padding buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
      child: CustomPrimaryButton(
        text: "I feel ${controller.selectedMood.value}",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: () {},
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: CustomBackButton(icon: MyIcons.xmark),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
    );
  }
}
