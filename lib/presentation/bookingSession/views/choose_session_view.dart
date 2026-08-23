import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/bookingSession/controllers/booking_session_controller.dart';
import 'package:Mentora/presentation/bookingSession/widgets/date_selector.dart';
import 'package:Mentora/presentation/bookingSession/widgets/time_slot_selector.dart';

class ChooseSessionView extends GetView<BookingSessionController> {
  const ChooseSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.timeSlots.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Spacing.s20.h,
            _buildDateSelector(context),
            Spacing.s24.h,
            _buildTimeSlotsSection(context),
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
        horizontal: Spacing.s8.symmetric.horizontal +
            Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Date & Time",
            style: h2.copyWith(
              color: theme.textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s8.h,
          Text(
            "Select when you would like to connect.",
            style: r14.copyWith(
              color: theme.textTheme.bodySmall!.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Obx(() {
      return DateSelector(
        dates: controller.availableDates,
        selectedDate: controller.selectedDate.value ?? DateTime.now(),
        onDateSelected: controller.selectDate,
      );
    });
  }

  Widget _buildTimeSlotsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal +
                Spacing.s4.symmetric.horizontal,
          ),
          child: Text(
            "Available Times",
            style: r16.copyWith(
              color: theme.textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacing.s12.h,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
          ),
          child: Obx(() {
            if (controller.timeSlots.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "No available slots for this date.",
                    style: r14.copyWith(
                      color: theme.textTheme.bodySmall!.color,
                    ),
                  ),
                ),
              );
            }

            return TimeSlotSelector(
              slots: controller.timeSlots,
              selectedSlot: controller.selectedTimeSlot.value,
              onSlotSelected: controller.selectTimeSlot,
            );
          }),
        ),
      ],
    );
  }
}
