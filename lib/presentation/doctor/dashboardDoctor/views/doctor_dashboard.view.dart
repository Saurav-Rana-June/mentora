import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/views/appointment_detail.dialog.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/views/cancel_session.dialog.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/views/complete_session.dialog.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/views/start_session_call.dialog.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_appointment_card.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/dashboard_doctor.controller.dart';
import '../../landingDoctor/controllers/landing_doctor.controller.dart';

class DoctorDashboardView extends GetView<DashboardDoctorController> {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DashboardDoctorController>()) {
      Get.put(DashboardDoctorController());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStatCardsGrid(context),
          Spacing.s24.h,
          buildQuickActionsSection(context),
          Spacing.s24.h,
          buildTodayAppointmentsSection(context),
          Spacing.s24.h,
          buildActivityAndFeedbackSection(context),
        ],
      ),
    );
  }

  // --- Stat Cards Grid ---
  Widget buildStatCardsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 1050
            ? 4
            : (constraints.maxWidth > 650
                  ? 2
                  : (constraints.maxWidth > 340 ? 2 : 1));

        final double childAspectRatio = crossAxisCount == 1
            ? 2.8
            : (crossAxisCount == 2
                  ? (constraints.maxWidth <= 650 ? 1.30 : 1.85)
                  : 1.65);

        final double spacing = constraints.maxWidth < 600 ? 10 : 14;

        return Obx(() {
          final todayCount = controller.todayAppointments.length;
          final totalPt = controller.totalPatients.value;
          final rate = controller.rating.value;
          final earnings = controller.totalEarnings.value;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildStatCard(
                context: context,
                title: "Today's Schedule",
                value: '$todayCount Sessions',
                badge: 'Live Today',
                icon: '\u{f073}', // calendar-alt
                iconColor: primary,
                onTap: () {
                  if (Get.isRegistered<LandingDoctorController>()) {
                    Get.find<LandingDoctorController>().changeMenuIndex(1);
                  }
                },
              ),
              buildStatCard(
                context: context,
                title: 'Total Patients',
                value: '$totalPt',
                badge: controller.patientsGrowth.value,
                icon: '\u{f0c0}', // users
                iconColor: infoColor,
                onTap: () {
                  if (Get.isRegistered<LandingDoctorController>()) {
                    Get.find<LandingDoctorController>().changeMenuIndex(2);
                  }
                },
              ),
              buildStatCard(
                context: context,
                title: 'Trust Rating',
                value: '${rate.toStringAsFixed(2)} ★',
                badge: '${controller.reviewsCount.value} Reviews',
                icon: '\u{f005}', // star
                iconColor: warningColor,
              ),
              buildStatCard(
                context: context,
                title: 'Monthly Earnings',
                value: '\$${earnings.toStringAsFixed(0)}',
                badge: controller.earningsGrowth.value,
                icon: '\u{f51e}', // coins
                iconColor: successColor,
              ),
            ],
          );
        });
      },
    );
  }

  Widget buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String badge,
    required String icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isMobile = AppScale.isMobile;

    return CustomPrimaryCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: r12.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 13,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value,
                    style: h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                  Text(
                    badge,
                    style: r12.copyWith(
                      color: iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: r14.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacing.s4.h,
                        Text(
                          value,
                          style: h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.headlineLarge?.color,
                          ),
                        ),
                        Spacing.s4.h,
                        Text(
                          badge,
                          style: r12.copyWith(
                            color: iconColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacing.s8.w,
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 18,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // --- Quick Clinical Actions ---
  Widget buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppScale.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Clinical Actions',
          style: (isMobile ? r18 : h3).copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        Spacing.s12.h,
        Wrap(
          spacing: isMobile ? 8 : 10,
          runSpacing: isMobile ? 8 : 10,
          children: [
            buildQuickActionButton(
              context: context,
              label: 'Start Next Video Call',
              icon: '\u{f03d}',
              onTap: () {
                if (controller.todayAppointments.isNotEmpty) {
                  StartSessionCallDialog.show(
                    context: context,
                    appointment: controller.todayAppointments.first,
                  );
                } else if (controller.allAppointments.isNotEmpty) {
                  StartSessionCallDialog.show(
                    context: context,
                    appointment: controller.allAppointments.first,
                  );
                } else {
                  Get.snackbar(
                    'No Consultations',
                    'You have no scheduled consultations at this time.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            buildQuickActionButton(
              context: context,
              label: 'View Appointments',
              icon: '\u{f073}',
              onTap: () {
                if (Get.isRegistered<LandingDoctorController>()) {
                  Get.find<LandingDoctorController>().changeMenuIndex(1);
                }
              },
            ),
            buildQuickActionButton(
              context: context,
              label: 'Patient Records',
              icon: '\u{f0c0}',
              onTap: () {
                if (Get.isRegistered<LandingDoctorController>()) {
                  Get.find<LandingDoctorController>().changeMenuIndex(2);
                }
              },
            ),
            buildQuickActionButton(
              context: context,
              label: 'Manage Availability',
              icon: '\u{f017}',
              onTap: () {
                if (Get.isRegistered<LandingDoctorController>()) {
                  Get.find<LandingDoctorController>().changeMenuIndex(3);
                }
              },
            ),
            buildQuickActionButton(
              context: context,
              label: 'Doctor Profile & Rates',
              icon: '\u{f4fe}',
              onTap: () {
                if (Get.isRegistered<LandingDoctorController>()) {
                  Get.find<LandingDoctorController>().changeMenuIndex(4);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildQuickActionButton({
    required BuildContext context,
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = AppScale.isMobile;

    return Material(
      color: isDark ? const Color(0xFF242522) : const Color(0xFFF6F8F2),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: primary.withValues(alpha: isDark ? 0.2 : 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14,
                  color: primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: r14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Today's Schedule ---
  Widget buildTodayAppointmentsSection(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppScale.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Patient Schedule",
                  style: (isMobile ? r18 : h3).copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  'Upcoming telehealth consultations scheduled for today.',
                  style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                if (Get.isRegistered<LandingDoctorController>()) {
                  Get.find<LandingDoctorController>().changeMenuIndex(1);
                }
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('View All'),
            ),
          ],
        ),
        Spacing.s12.h,
        Obx(() {
          final list = controller.todayAppointments;
          if (list.isEmpty) {
            return CustomPrimaryCard(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: primary, size: 36),
                      Spacing.s8.h,
                      Text(
                        'All Caught Up for Today!',
                        style: h3.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacing.s4.h,
                      Text(
                        'No further consultations booked for today.',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => Spacing.s12.h,
            itemBuilder: (context, index) {
              final item = list[index];
              return DoctorAppointmentCard(
                appointment: item,
                onStartSession: () => StartSessionCallDialog.show(
                  context: context,
                  appointment: item,
                ),
                onCancelSession: () => CancelSessionDialog.show(
                  context: context,
                  appointment: item,
                ),
                onCompleteSession: () => CompleteSessionDialog.show(
                  context: context,
                  appointment: item,
                ),
                onViewDetails: () => AppointmentDetailDialog.show(
                  context: context,
                  appointment: item,
                ),
              );
            },
          );
        }),
      ],
    );
  }

  // --- Activity and Feedback Section ---
  Widget buildActivityAndFeedbackSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final wv = controller.weeklyVolume.value;
      final dailyList = wv?.dailyVolume ?? [];
      int maxCount = 8;
      if (dailyList.isNotEmpty) {
        for (final item in dailyList) {
          if (item.consultationsCount > maxCount) {
            maxCount = item.consultationsCount;
          }
        }
      }

      final reviews = controller.recentReviews;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          final weeklyActivity = CustomPrimaryCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Consultation Volume',
                        style: h3.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '${wv?.totalWeeklySessions ?? 32} Sessions',
                          style: r10.copyWith(fontWeight: FontWeight.w700, color: primary),
                        ),
                      ),
                    ],
                  ),
                  Spacing.s16.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: dailyList.isNotEmpty
                        ? dailyList
                            .map((d) => buildDayBar(
                                  context,
                                  d.day,
                                  d.consultationsCount,
                                  maxCount,
                                  isDark,
                                ))
                            .toList()
                        : [
                            buildDayBar(context, 'Mon', 6, 8, isDark),
                            buildDayBar(context, 'Tue', 8, 8, isDark),
                            buildDayBar(context, 'Wed', 5, 8, isDark),
                            buildDayBar(context, 'Thu', 7, 8, isDark),
                            buildDayBar(context, 'Fri', 4, 8, isDark),
                            buildDayBar(context, 'Sat', 2, 8, isDark),
                            buildDayBar(context, 'Sun', 0, 8, isDark),
                          ],
                  ),
                  Spacing.s16.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completion: ${wv?.completionRate ?? "98.4%"}',
                        style: r12.copyWith(color: successColor, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Avg Duration: ${wv?.avgDurationMinutes ?? 45} min',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

          final patientFeedback = CustomPrimaryCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Patient Reviews',
                        style: h3.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Icon(Icons.star_rounded, color: warningColor),
                    ],
                  ),
                  Spacing.s16.h,
                  if (reviews.isNotEmpty)
                    for (int i = 0; i < reviews.length && i < 3; i++) ...[
                      if (i > 0) Spacing.s12.h,
                      buildFeedbackItem(
                        patient: reviews[i].patientName,
                        rating: reviews[i].rating,
                        comment: reviews[i].comment,
                        timeAgo: reviews[i].timeAgo,
                      ),
                    ]
                  else ...[
                    buildFeedbackItem(
                      patient: 'Elena Rostova',
                      rating: 5,
                      comment: 'Dr. Sarah was exceptionally empathetic and practical.',
                      timeAgo: 'Yesterday',
                    ),
                    Spacing.s12.h,
                    buildFeedbackItem(
                      patient: 'Benjamin Vance',
                      rating: 5,
                      comment: 'Outstanding sessions that transformed my anxiety levels.',
                      timeAgo: '4d ago',
                    ),
                  ],
                ],
              ),
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: weeklyActivity),
                Spacing.s16.w,
                Expanded(flex: 2, child: patientFeedback),
              ],
            );
          }

          return Column(
            children: [
              weeklyActivity,
              Spacing.s16.h,
              patientFeedback,
            ],
          );
        },
      );
    });
  }

  Widget buildDayBar(BuildContext context, String day, int count, int maxCount, bool isDark) {
    final heightRatio = (count / maxCount).clamp(0.08, 1.0);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '$count',
          style: r10.copyWith(fontWeight: FontWeight.w600, color: primary),
        ),
        Spacing.s4.h,
        Container(
          width: 24,
          height: 80 * heightRatio,
          decoration: BoxDecoration(
            color: count > 0 ? primary : (isDark ? slate[800] : slate[200]),
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        Spacing.s4.h,
        Text(
          day,
          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  Widget buildFeedbackItem({
    required String patient,
    required int rating,
    required String comment,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patient,
                style: r12.copyWith(fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  for (int i = 0; i < rating; i++)
                    Icon(Icons.star_rounded, color: warningColor, size: 14),
                  Spacing.s4.w,
                  Text(timeAgo, style: r10.copyWith(color: slate[400])),
                ],
              ),
            ],
          ),
          Spacing.s4.h,
          Text(
            '"$comment"',
            style: r12.copyWith(fontStyle: FontStyle.italic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
