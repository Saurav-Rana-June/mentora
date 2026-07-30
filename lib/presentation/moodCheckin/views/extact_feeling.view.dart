import 'package:Mentora/presentation/moodCheckin/controllers/mood_checkin.controller.dart';
import 'package:Mentora/widgets/others/custom.reason.card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';

class ExtactFeelingView extends GetView<MoodCheckinController> {
  const ExtactFeelingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What is your extact feeling?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Spacing.s20.h,

          Expanded(
            child: GridView.builder(
              itemCount: controller.exactReasonsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: Spacing.s12.value,
                mainAxisSpacing: Spacing.s12.value,
                childAspectRatio: 0.90,
              ),
              itemBuilder: (context, index) {
                return Obx(() {
                  final extactReason = controller.exactReasonsList[index];
                  final bool exists = controller.selectedExtactReasonsList.any(
                    (reason) => reason.label == extactReason.label,
                  );

                  return CustomReasonCard(
                    icon: extactReason.icon,
                    label: extactReason.label,
                    isSelected: exists,
                    onTap: () => controller.toggleExtactReason(extactReason),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
