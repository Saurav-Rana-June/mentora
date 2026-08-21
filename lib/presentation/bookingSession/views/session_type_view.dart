import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/booking_session_controller.dart';

class SessionTypeView extends GetView<BookingSessionController> {
  const SessionTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final doctor = controller.selectedDoctor.value;
      if (doctor == null) {
        return const Center(child: Text("No doctor selected"));
      }

      final List<Map<String, dynamic>> modalities = [
        if (doctor.videoCallFeature != false)
          {
            "type": "Video Call",
            "title": "Video Session",
            "description":
                "Face-to-face virtual counseling in a private, secure video call.",
            "icon": Icons.videocam_rounded,
          },
        if (doctor.callFeature != false)
          {
            "type": "Voice Call",
            "title": "Voice Session",
            "description":
                "Private audio-only counseling for complete voice comfort.",
            "icon": Icons.phone_rounded,
          },
      ];

      final List<int> durations = [15, 30, 45, 60];
      final hourlyRate = doctor.startingPricePerHour ?? 100.0;
      final activeModality = controller.selectedSessionType.value;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    Spacing.s8.symmetric.horizontal +
                    Spacing.s4.symmetric.horizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Session Type",
                    style: h2.copyWith(
                      color: theme.textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacing.s8.h,
                  Text(
                    "Select how you would like to connect and the session duration.",
                    style: r14.copyWith(
                      color: theme.textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s24.h,

            // Modality Cards Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    Spacing.s8.symmetric.horizontal +
                    Spacing.s4.symmetric.horizontal,
              ),
              child: Text(
                "1. Select Modality",
                style: r16.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacing.s12.h,

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
              ),
              child: Row(
                children: List.generate(modalities.length, (index) {
                  final mod = modalities[index];
                  final type = mod["type"] as String;
                  final title = mod["title"] as String;
                  final description = mod["description"] as String;
                  final icon = mod["icon"] as IconData;

                  final isSelected = activeModality == type;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.setSessionType(type);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(
                          horizontal: Spacing.s4.symmetric.horizontal,
                        ),
                        padding: EdgeInsets.all(
                          Spacing.s16.symmetric.horizontal,
                        ),
                        height: 160.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withValues(alpha: isDark ? 0.08 : 0.04)
                              : theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isSelected
                                ? primary
                                : theme.dividerColor.withValues(alpha: 0.1),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 36.h,
                                  width: 36.h,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primary.withValues(alpha: 0.15)
                                        : (isDark ? slate[800] : slate[100]),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? primary
                                          : (isDark ? slate[300] : slate[600]),
                                      size: 18.r,
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 18.r,
                                  width: 18.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? primary
                                          : (isDark
                                                ? slate[600]!
                                                : slate[300]!),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 10.r,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                            Spacing.s16.h,
                            Text(
                              title,
                              style: r14.copyWith(
                                color: theme.textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.s4.h,
                            Expanded(
                              child: Text(
                                description,
                                style: r12.copyWith(
                                  color: theme.textTheme.bodyMedium!.color,
                                  height: 1.25,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Spacing.s32.h,

            // Duration Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    Spacing.s8.symmetric.horizontal +
                    Spacing.s4.symmetric.horizontal,
              ),
              child: Text(
                "2. Select Duration",
                style: r16.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacing.s12.h,

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: Spacing.s8.symmetric.horizontal,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: durations.length,
                itemBuilder: (context, index) {
                  final min = durations[index];
                  final isSelected = controller.selectedDuration.value == min;
                  final multiplier = activeModality == "Video Call" ? 1.0 : 0.8;
                  final calculatedPrice =
                      hourlyRate * (min / 60.0) * multiplier;

                  return GestureDetector(
                    onTap: () {
                      controller.setSessionDuration(min);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primary.withValues(alpha: isDark ? 0.08 : 0.04)
                            : theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? primary
                              : theme.dividerColor.withValues(alpha: 0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$min mins",
                              style: r14.copyWith(
                                color: theme.textTheme.bodyLarge!.color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                            Spacing.s4.h,
                            Text(
                              "\$${calculatedPrice.toStringAsFixed(0)}",
                              style: r12.copyWith(
                                color: isSelected
                                    ? primary
                                    : theme.textTheme.bodySmall!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacing.s32.h,

            // Package Summary Card
            Container(
              margin: EdgeInsets.symmetric(
                horizontal:
                    Spacing.s8.symmetric.horizontal +
                    Spacing.s4.symmetric.horizontal,
              ),
              padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_outlined, size: 22.r, color: primary),
                  Spacing.s12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Session Package",
                          style: r14.copyWith(
                            color: theme.textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.s8.h,
                        Text(
                          "You've chosen a ${controller.selectedDuration.value}-minute ${activeModality == 'Video Call' ? 'Video Consultation' : 'Voice Session'} with ${doctor.name}.",
                          style: r12.copyWith(
                            color: theme.textTheme.bodyMedium!.color!
                                .withValues(alpha: 0.9),
                            height: 1.35,
                          ),
                        ),
                        Spacing.s8.h,
                        Text(
                          "Total Fee: \$${controller.sessionPrice.value.toStringAsFixed(0)}",
                          style: r14.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s24.h,
          ],
        ),
      );
    });
  }
}
