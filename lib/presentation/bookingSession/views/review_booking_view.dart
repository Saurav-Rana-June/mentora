import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/booking_session_controller.dart';
import '../widgets/booking_summary_card.dart';

class ReviewBookingView extends GetView<BookingSessionController> {
  const ReviewBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Review your session",
                  style: h2.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacing.s8.h,
                Text(
                  "Verify your appointment details before booking.",
                  style: r14.copyWith(
                    color: theme.textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Spacing.s20.h,

          // Summary Card
          Obx(() {
            if (controller.selectedDoctor.value == null ||
                controller.selectedDate.value == null ||
                controller.selectedTimeSlot.value == null) {
              return const Center(child: Text("Missing booking details."));
            }

            return BookingSummaryCard(
              expert: controller.selectedDoctor.value!,
              date: controller.selectedDate.value!,
              timeSlot: controller.selectedTimeSlot.value!,
              sessionType: controller.selectedSessionType.value,
              notes: controller.sessionNotes.value,
            );
          }),
          Spacing.s24.h,

          // Cancellation Info
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
            decoration: BoxDecoration(
              color: slate[100]!.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20.r, color: slate[500]),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cancellation Policy",
                        style: r14.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        "Cancel or reschedule for free up to 24 hours before your scheduled session. Late cancellations may incur a fee.",
                        style: r12.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.withValues(
                            alpha: 0.8,
                          ),
                          height: 1.4,
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
  }
}
