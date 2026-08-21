import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/booking_session_controller.dart';
import '../widgets/date_selector.dart';
import '../widgets/time_slot_selector.dart';

class ChooseSessionView extends GetView<BookingSessionController> {
  const ChooseSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Padding(
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
          ),
          Spacing.s20.h,

          // Date Selector
          Obx(() {
            return DateSelector(
              dates: controller.availableDates,
              selectedDate: controller.selectedDate.value ?? DateTime.now(),
              onDateSelected: controller.selectDate,
            );
          }),
          Spacing.s24.h,



          // Time Slots Grid
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
          Spacing.s24.h,
        ],
      ),
    );
  }
}
