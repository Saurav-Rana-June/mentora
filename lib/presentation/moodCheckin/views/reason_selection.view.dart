import 'package:Mentora/presentation/moodCheckin/controllers/mood_checkin.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../../infrastructure/theme/theme.dart';

class ReasonSelection extends GetView<MoodCheckinController> {
  const ReasonSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What is the reason that makes you feel that way?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Spacing.s20.h,

          Expanded(
            child: GridView.builder(
              itemCount: controller.moodReasonsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return Obx(() {
                  final reason = controller.moodReasonsList[index];
                  final bool exists = controller.selectedMoodReasonsList.any(
                    (mood) => mood.label == reason.label,
                  );
                  return Padding(
                    padding: EdgeInsets.all(Spacing.s8.value),
                    child: InkWell(
                      onTap: () => controller.toggleMoodReason(reason),
                      child: Container(
                        height: 100,
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: exists
                              ? primary
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              reason.icon,
                              style: h2.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacing.s4.h,
                            Text(
                              reason.label,
                              textAlign: TextAlign.center,
                              style: r14.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
