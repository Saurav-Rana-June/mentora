import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/presentation/insights/controllers/insights.controller.dart';
import 'package:Mentora/presentation/moodCheckin/views/add_notes.view.dart';
import 'package:Mentora/presentation/moodCheckin/views/mood_history.view.dart';
import 'package:Mentora/presentation/moodCheckin/views/extact_feeling.view.dart';
import 'package:Mentora/presentation/moodCheckin/views/mood_selection.veiw.dart';
import 'package:Mentora/presentation/moodCheckin/views/reason_selection.view.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:Mentora/widgets/others/custom.primary.bottombar.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
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
    return CustomScreenWrapper(
      safeAreaTop: false,
      appBar: buildAppbar(context),
      body: Obx(() => bodyWidget(controller.currentIndex.value)),
      bottomNavigationBar: Obx(() => buildButton()),
    );
  }

  Widget buildButton() {
    return CustomPrimaryBottomBar(
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
                    if (Get.isRegistered<GlobalController>()) {
                      controller.globalController.addMoodCheckin(
                        controller.selectedMood.value,
                      );
                      controller.globalController.fetchMoodTrackerStats(
                        forceRefresh: true,
                      );
                      Get.find<InsightsController>().fetchGrowthAreas(
                        DateFilter.thisWeek,
                        forceRefresh: true,
                      );
                      Get.find<InsightsController>().fetchCoachingBanner(
                        forceRefresh: true,
                      );
                    }
                    Get.back();
                  }
                }
              },
      ),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      leading: CustomBackButton(icon: MyIcons.xmark),
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Text(
            '\u{f1da}',
            style: TextStyle(
              fontFamily: 'FontAwesomeLight',
              fontSize: 18.sp,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          onPressed: () {
            controller.globalController.selectedDateFilter.value =
                DateFilter.thisWeek;
            controller.globalController.fetchMoodHistory();
            Get.to(
              () => const MoodHistoryView(),
              transition: Transition.rightToLeft,
            );
          },
        ),
        Spacing.s16.w,
      ],
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
