import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:Mentora/presentation/doctor/landingDoctor/controllers/landing_doctor.controller.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_appointment_card.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_stat_card.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/dashboard_doctor.controller.dart';

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
          buildHeroWelcomeCard(context),
          Spacing.s20.h,
          buildStatCardsGrid(context),
          Spacing.s24.h,
          buildTodayAppointmentsSection(context),
          Spacing.s24.h,
          buildActivityAndFeedbackSection(context),
        ],
      ),
    );
  }

  Widget buildHeroWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final doc = controller.doctorProfile.value;
      final docName = doc?.name ?? 'Dr. Sarah Jenkins, MD';
      final speciality = doc?.speciality ?? 'Clinical Psychologist';
      final image = doc?.image ?? 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500';
      final isOnline = controller.isOnline.value;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F1D) : white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            final leftInfo = Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const CircleAvatar(
                          radius: 32,
                          child: Icon(Icons.person, size: 32),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isOnline ? successColor : slate[400],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF1E1F1D) : white,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.s16.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              docName,
                              style: h2.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacing.s8.w,
                          DoctorBadge(
                            text: 'CLINICALLY VERIFIED',
                            icon: '\u{f0f0}',
                            color: primary,
                          ),
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        '$speciality • Mentora Doctors Clinical Care Portal',
                        style: r14.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      Spacing.s4.h,
                      Row(
                        children: [
                          Text(
                            isOnline ? 'Online • Available for Consultations' : 'Offline / In Consultation',
                            style: r12.copyWith(
                              color: isOnline ? successColor : theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.s8.w,
                          Transform.scale(
                            scale: 0.8,
                            child: Switch.adaptive(
                              value: isOnline,
                              activeTrackColor: primary,
                              activeThumbColor: primary,
                              onChanged: controller.toggleOnlineStatus,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  leftInfo,
                  Spacing.s16.h,
                  buildHeroQuickActions(context),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 3, child: leftInfo),
                Spacing.s16.w,
                buildHeroQuickActions(context),
              ],
            );
          },
        ),
      );
    });
  }

  Widget buildHeroQuickActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPrimaryButton(
          text: 'Start Next Session',
          backgroundColor: primary,
          prefixIcon: const Text(
            '\u{f03d}',
            style: TextStyle(
              fontFamily: 'FontAwesomeSolid',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          onPressed: () {
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
                'No Pending Sessions',
                'You have no scheduled consultations at this moment.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildStatCardsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 1050
            ? 4
            : (constraints.maxWidth > 650 ? 2 : (constraints.maxWidth > 340 ? 2 : 1));

        final double childAspectRatio = crossAxisCount == 1
            ? 2.8
            : (crossAxisCount == 2
                ? (constraints.maxWidth <= 650 ? 1.35 : 1.85)
                : 1.65);

        final double spacing = constraints.maxWidth < 600 ? 10 : 14;

        return Obx(() {
          final todayCount = controller.todayAppointments.length;
          final totalPt = controller.totalPatients.value;
          final rate = controller.rating.value;
          final reviews = controller.reviewsCount.value;
          final earnings = controller.totalEarnings.value;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DoctorStatCard(
                title: "Today's Consultations",
                value: '$todayCount Sessions',
                badge: 'Live Today',
                badgeColor: successColor,
                icon: '\u{f073}', // calendar-alt
                iconColor: primary,
                onTap: () {
                  if (Get.isRegistered<LandingDoctorController>()) {
                    Get.find<LandingDoctorController>().changeMenuIndex(1);
                  }
                },
              ),
              DoctorStatCard(
                title: 'Total Patients Treated',
                value: '$totalPt',
                badge: '+14 this month',
                badgeColor: infoColor,
                icon: '\u{f0c0}', // users
                iconColor: infoColor,
              ),
              DoctorStatCard(
                title: 'Clinical Trust Rating',
                value: '${rate.toStringAsFixed(2)} ★',
                badge: '$reviews Reviews',
                badgeColor: warningColor,
                icon: '\u{f005}', // star
                iconColor: warningColor,
              ),
              DoctorStatCard(
                title: 'Monthly Telehealth Revenue',
                value: '\$${earnings.toStringAsFixed(0)}',
                badge: '+\$650 this week',
                badgeColor: primary,
                icon: '\u{f51e}', // coins
                iconColor: primary,
              ),
            ],
          );
        });
      },
    );
  }

  Widget buildTodayAppointmentsSection(BuildContext context) {
    final theme = Theme.of(context);

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
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  'Upcoming telehealth consultations scheduled for today.',
                  style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
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
              label: const Text('View All Appointments'),
            ),
          ],
        ),
        Spacing.s16.h,
        Obx(() {
          final list = controller.todayAppointments;
          if (list.isEmpty) {
            return CustomPrimaryCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: primary, size: 40),
                      Spacing.s12.h,
                      Text(
                        'All Caught Up for Today!',
                        style: h3.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacing.s4.h,
                      Text(
                        'No further consultations booked for today. You can open more availability in your schedule.',
                        style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
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

  Widget buildActivityAndFeedbackSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                        'This Week: 32 Sessions',
                        style: r10.copyWith(fontWeight: FontWeight.w700, color: primary),
                      ),
                    ),
                  ],
                ),
                Spacing.s16.h,
                // Activity Bar representation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                      'Session Completion: 98.4%',
                      style: r12.copyWith(color: successColor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Avg Duration: 45 min',
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
                      'Recent Patient Feedback',
                      style: h3.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.star_rounded, color: warningColor),
                  ],
                ),
                Spacing.s16.h,
                buildFeedbackItem(
                  patient: 'Elena Rostova',
                  rating: 5,
                  comment: 'Dr. Sarah was exceptionally empathetic and practical. I felt genuinely understood.',
                  timeAgo: 'Yesterday',
                ),
                Spacing.s12.h,
                buildFeedbackItem(
                  patient: 'Benjamin Vance',
                  rating: 5,
                  comment: 'Outstanding therapy sessions that transformed my daily productivity and anxiety levels.',
                  timeAgo: '4 days ago',
                ),
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
          height: 90 * heightRatio,
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
