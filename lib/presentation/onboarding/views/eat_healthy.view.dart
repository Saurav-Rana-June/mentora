import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/onboarding.controller.dart';

class EatHealthyView extends StatelessWidget {
  EatHealthyView({super.key});

  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
      child: Column(
        children: [
          Text(
            "Do you eat healhily?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Text(
            "How would ypu describe your eating habits? Your diet can impact your mentalwll-being.",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          Spacing.s32.h,

          Expanded(
            child: ListView.builder(
              itemCount: controller.eatingHealthyStatusList.length,
              itemBuilder: (context, index) {
                var eatingStatus = controller.eatingHealthyStatusList[index];

                return Obx(() {
                  final isSelected =
                      controller.selectedEatingHealthyStatus.value ==
                      eatingStatus;
                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashColor: slate[100],
                          onTap: () {
                            controller.selectedEatingHealthyStatus.value =
                                eatingStatus;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(color: primary, width: 1.2)
                                  : Border.all(
                                      color: Theme.of(
                                        context,
                                      ).dividerTheme.color!,
                                      width: 1.2,
                                    ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.s8.symmetric.horizontal,
                              vertical: Spacing.s8.symmetric.horizontal,
                            ),

                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      eatingStatus,
                                      style: r16.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.headlineMedium!.color,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: primary,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!(index + 1 ==
                          controller.eatingHealthyStatusList.length))
                        Spacing.s16.h,
                    ],
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
