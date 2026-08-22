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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Spacing.s20.h,
          _buildSummaryCard(context),
          Spacing.s24.h,
          _buildCancellationPolicy(context),
          Spacing.s24.h,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
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
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Obx(() {
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
        price: controller.sessionPrice.value,
        duration: controller.selectedDuration.value,
      );
    });
  }

  Widget _buildCancellationPolicy(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Spacing.s4.symmetric.horizontal),
      padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: isDark ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: warningColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: warningColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18.r,
              color: warningColor,
            ),
          ),
          Spacing.s16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cancellation Policy",
                  style: r14.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  "Cancel or reschedule for free up to 24 hours before your scheduled session. Late cancellations may incur a fee.",
                  style: r12.copyWith(
                    color: theme.textTheme.bodyMedium!.color!.withValues(
                      alpha: 0.8,
                    ),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
