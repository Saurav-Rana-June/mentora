import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/others/custom.primary.card.dart';
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

      if (controller.isLoading.value && controller.apiModalities.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final List<Map<String, dynamic>> modalities = controller.apiModalities.map((item) {
        final type = item.type;
        return {
          "type": type,
          "title": item.title,
          "description": item.description,
          "icon": type == "Video Call" ? Icons.videocam_rounded : Icons.phone_rounded,
        };
      }).toList();

      final List<int> durations = controller.apiDurations.map((item) => item.minutes).toList();
      final hourlyRate = doctor.startingPricePerHour ?? 100.0;
      final activeModality = controller.selectedSessionType.value;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Spacing.s24.h,
            _buildModalitySection(context, activeModality, modalities, isDark),
            Spacing.s32.h,
            _buildDurationSection(
              context,
              activeModality,
              durations,
              hourlyRate,
              isDark,
            ),
            Spacing.s32.h,
            _buildSummarySection(context, activeModality, hourlyRate, doctor),
            Spacing.s24.h,
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            Spacing.s8.symmetric.horizontal + Spacing.s4.symmetric.horizontal,
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
    );
  }

  Widget _buildModalitySection(
    BuildContext context,
    String activeModality,
    List<Map<String, dynamic>> modalities,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: Column(
            children: List.generate(modalities.length, (index) {
              final mod = modalities[index];
              final type = mod["type"] as String;
              final title = mod["title"] as String;
              final description = mod["description"] as String;
              final icon = mod["icon"] as IconData;

              final isSelected = activeModality == type;

              return GestureDetector(
                onTap: () {
                  controller.setSessionType(type);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.only(
                    bottom: index == modalities.length - 1 ? 0 : 12.h,
                    left: Spacing.s4.symmetric.horizontal,
                    right: Spacing.s4.symmetric.horizontal,
                  ),
                  padding: EdgeInsets.all(Spacing.s8.symmetric.horizontal),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 44.h,
                        width: 44.h,
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
                            size: 22.r,
                          ),
                        ),
                      ),
                      Spacing.s16.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: r14.copyWith(
                                    color: theme.textTheme.bodyLarge!.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacing.s8.w,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primary.withValues(alpha: 0.15)
                                        : (isDark ? slate[800] : slate[100]),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    type == "Video Call"
                                        ? "HD Video"
                                        : "Voice Only",
                                    style: r10.copyWith(
                                      color: isSelected
                                          ? primary
                                          : (isDark ? slate[300] : slate[600]),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacing.s4.h,
                            Text(
                              description,
                              style: r12.copyWith(
                                color: theme.textTheme.bodyMedium!.color,
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Spacing.s16.w,
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 20.r,
                        width: 20.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? primary
                                : (isDark ? slate[600]! : slate[300]!),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, size: 12.r, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSection(
    BuildContext context,
    String activeModality,
    List<int> durations,
    double hourlyRate,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              childAspectRatio: 1.4,
              crossAxisSpacing: Spacing.s8.symmetric.horizontal,
              mainAxisSpacing: 16.h,
            ),
            itemCount: durations.length,
            itemBuilder: (context, index) {
              final min = durations[index];
              final isSelected = controller.selectedDuration.value == min;
              final durationItem = controller.apiDurations.firstWhereOrNull(
                (d) => d.minutes == min,
              );
              final calculatedPrice = activeModality == "Video Call"
                  ? (durationItem?.videoCallPrice ?? (hourlyRate * (min / 60.0) * 1.0))
                  : (durationItem?.voiceCallPrice ?? (hourlyRate * (min / 60.0) * 0.8));
              final durationSubtitle = durationItem?.subtitle ?? "Consultation";

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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s12.symmetric.horizontal,
                      // vertical: Spacing.s8.symmetric.vertical,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$min mins",
                          style: r16.copyWith(
                            color: theme.textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.s4.h,
                        Text(
                          durationSubtitle,
                          style: r10.copyWith(
                            color: theme.textTheme.bodySmall!.color,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacing.s8.h,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primary
                                : (isDark ? slate[800] : slate[100]),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "\$${calculatedPrice.toStringAsFixed(0)}",
                            style: r12.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.bold,
                            ),
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
      ],
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    String activeModality,
    double hourlyRate,
    dynamic doctor,
  ) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      margin: EdgeInsets.symmetric(horizontal: Spacing.s8.symmetric.horizontal),
      padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
      borderRadius: 16.r,
      border: Border.all(
        color: theme.dividerColor.withValues(alpha: 0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(doctor.image ?? ''),
                backgroundColor: theme.primaryColorLight,
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name ?? "Therapist",
                      style: r16.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      doctor.speciality ?? "Mental Health Professional",
                      style: r14.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 14.r,
                      color: successColor,
                    ),
                    Spacing.s4.w,
                    Text(
                      "Verified",
                      style: r10.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 24.h,
            color: theme.dividerColor.withValues(alpha: 0.08),
            thickness: 1,
          ),
          _buildSummaryRow(
            context,
            label: "Modality",
            value: activeModality == "Video Call"
                ? "Video Session"
                : "Voice Session",
            icon: activeModality == "Video Call"
                ? Icons.videocam_rounded
                : Icons.phone_rounded,
          ),
          Spacing.s8.h,
          _buildSummaryRow(
            context,
            label: "Duration",
            value: "${controller.selectedDuration.value} mins",
            icon: Icons.access_time_filled_rounded,
          ),
          Spacing.s8.h,
          _buildSummaryRow(
            context,
            label: "Hourly Rate",
            value: "\$${hourlyRate.toStringAsFixed(0)}/hr",
            icon: Icons.monetization_on_rounded,
          ),
          Divider(
            height: 24.h,
            color: theme.dividerColor.withValues(alpha: 0.08),
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Fee",
                style: r16.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${controller.sessionPrice.value.toStringAsFixed(0)}",
                style: h3.copyWith(color: primary, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16.r,
              color: theme.textTheme.bodySmall!.color!.withValues(alpha: 0.7),
            ),
            Spacing.s8.w,
            Text(
              label,
              style: r14.copyWith(
                color: theme.textTheme.bodySmall!.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: r16.copyWith(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
