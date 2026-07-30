import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/presentation/moodCheckin/views/add_notes.view.dart';
import 'package:Mentora/presentation/moodCheckin/views/extact_feeling.view.dart';
import 'package:Mentora/presentation/moodCheckin/views/mood_selection.veiw.dart';
import 'package:Mentora/presentation/moodCheckin/views/reason_selection.view.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/mood_checkin.controller.dart';

class MoodCheckinScreen extends GetView<MoodCheckinController> {
  const MoodCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: buildAppbar(context),
        body: Obx(() => bodyWidget(controller.currentIndex.value)),
        bottomNavigationBar: Obx(() => buildButton()),
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
        text: controller.currentIndex.value == 3 ? "Save" : "Continue",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: controller.isLoading.value,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: controller.isLoading.value
            ? null
            : () async {
                if (controller.currentIndex.value < 3) {
                  controller.currentIndex.value++;
                } else {
                  final success = await controller.saveCheckIn();
                  if (success) {
                    if (Get.isRegistered<HomeController>()) {
                      Get.find<HomeController>().addMoodCheckin(
                        controller.selectedMood.value,
                      );
                    }
                    Get.back();
                  }
                }
              },
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: CustomBackButton(icon: MyIcons.xmark),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }

  Widget bodyWidget(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return MoodSelectionView();
      case 1:
        return ReasonSelection();
      case 2:
        return ExtactFeelingView();
      case 3:
        return AddNotesView();
      default:
        return const SizedBox();
    }
  }
}
