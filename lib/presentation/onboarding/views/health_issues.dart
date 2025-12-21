import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/onboarding.controller.dart';

class HealthIssuesView extends StatelessWidget {
  HealthIssuesView({super.key});

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
            "What causes your mental health issues?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Text(
            "What factor contribute to your mental health issues? (select all that apply)",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          Spacing.s32.h,

          Expanded(
            child: ListView.builder(
              itemCount: controller.mentalHealthIssuesCausesList.length,
              itemBuilder: (context, index) {
                var mainCause = controller.mentalHealthIssuesCausesList[index];

                return Obx(() {
                  final isIncluded = controller
                      .selectedMentalHealthIssuesCausesList
                      .contains(mainCause)
                      .obs;
                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashColor: slate[100],
                          onTap: () {
                            if (isIncluded.value) {
                              controller.selectedMentalHealthIssuesCausesList
                                  .remove(mainCause);
                            } else {
                              controller.selectedMentalHealthIssuesCausesList
                                  .add(mainCause);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: isIncluded.value
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

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mainCause,
                                  style: r16.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium!.color,
                                  ),
                                ),

                                if (isIncluded.value)
                                  Icon(Icons.check, color: primary, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!(index + 1 ==
                          controller.mentalHealthIssuesCausesList.length))
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
