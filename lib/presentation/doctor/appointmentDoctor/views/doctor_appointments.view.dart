import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_appointment_card.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_section_header.widget.dart';
import '../controllers/appointment_doctor.controller.dart';
import 'appointment_detail.dialog.dart';
import 'cancel_session.dialog.dart';
import 'complete_session.dialog.dart';
import 'start_session_call.dialog.dart';

class DoctorAppointmentsView extends GetView<AppointmentDoctorController> {
  const DoctorAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    if (!Get.isRegistered<AppointmentDoctorController>()) {
      Get.put(AppointmentDoctorController());
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Search and Modality filter
          Obx(
            () => DoctorSectionHeader(
              title: 'Clinical Appointments',
              subtitle: 'Monitor telehealth video and voice consultations, start live sessions, and manage cancellations.',
              searchHint: 'Search by patient name, booking ID, or notes...',
              onSearchChanged: controller.onSearchChanged,
              onRefresh: controller.fetchAppointments,
              filterWidget: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF242522) : white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedModality.value,
                    isDense: true,
                    style: r14.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                    items: controller.modalityList.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(m),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.onModalityChanged(val);
                    },
                  ),
                ),
              ),
            ),
          ),

          // Status Filter Tabs Row with Badges
          buildStatusFilterTabs(context),
          Spacing.s20.h,

          // Appointments Grid / List
          Obx(() {
            if (controller.isLoading.value && controller.appointments.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final list = controller.filteredAppointments;
            if (list.isEmpty) {
              return buildEmptyState(context);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 850;
                final crossAxisCount = isWide ? 2 : 1;

                if (crossAxisCount == 1) {
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
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 310,
                  ),
                  itemCount: list.length,
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
              },
            );
          }),
        ],
      ),
    );
  }

  Widget buildStatusFilterTabs(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final currentTab = controller.selectedTab.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.tabList.map((tab) {
            final isSelected = currentTab == tab;
            int count = 0;
            if (tab == 'All') count = controller.allCount;
            if (tab == 'Upcoming') count = controller.upcomingCount;
            if (tab == 'Today') count = controller.todayCount;
            if (tab == 'Completed') count = controller.completedCount;
            if (tab == 'Cancelled') count = controller.cancelledCount;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => controller.onTabChanged(tab),
                borderRadius: BorderRadius.circular(10.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : (isDark ? const Color(0xFF222320) : white),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isSelected
                          ? primary
                          : (isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tab,
                        style: r14.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      Spacing.s4.w,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : (isDark ? slate[800] : slate[100]),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '$count',
                          style: r10.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '\u{f073}', // calendar
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 32,
                  color: primary,
                ),
              ),
            ),
            Spacing.s16.h,
            Text(
              'No Appointments Found',
              style: h3.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacing.s4.h,
            Text(
              'There are no appointments matching the selected filter or search query.',
              style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
              textAlign: TextAlign.center,
            ),
            Spacing.s16.h,
            ElevatedButton.icon(
              onPressed: () {
                controller.onTabChanged('All');
                controller.onSearchChanged('');
                controller.onModalityChanged('All Modalities');
              },
              icon: const Icon(Icons.clear_all_rounded, size: 18),
              label: const Text('Reset Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
