import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/buttons/custom_primary_button.widget.dart';
import '../controllers/booking_session_controller.dart';

class BookingSuccessView extends GetView<BookingSessionController> {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctorName = controller.selectedDoctor.value?.name ?? "Therapist";
    final formattedDate = controller.selectedDate.value != null
        ? controller.formatBookingDate(controller.selectedDate.value!)
        : "";
    final timeStr = controller.selectedTimeSlot.value?.time ?? "";
    final sessionType = controller.selectedSessionType.value;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.symmetric.horizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon animation/box
            Container(
              height: 72.h,
              width: 72.h,
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: successColor,
                  size: 48.r,
                ),
              ),
            ),
            Spacing.s24.h,

            // Text layout
            Text(
              "Your session is booked",
              style: h2.copyWith(
                color: theme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacing.s8.h,
            Text(
              "You're all set with $doctorName",
              style: r16.copyWith(
                color: theme.textTheme.bodyMedium!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacing.s32.h,

            // Clean session parameters card
            Container(
              padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    Icons.calendar_today_outlined,
                    formattedDate,
                  ),
                  Spacing.s12.h,
                  _buildDetailRow(context, Icons.access_time, timeStr),
                  Spacing.s12.h,
                  _buildDetailRow(
                    context,
                    sessionType == "Video Call"
                        ? Icons.videocam_outlined
                        : Icons.phone_outlined,
                    sessionType,
                  ),
                  Spacing.s12.h,
                  _buildDetailRow(
                    context,
                    Icons.payment_outlined,
                    "₹1,500 (Pay at session)",
                  ),
                ],
              ),
            ),
            Spacing.s40.h,

            // Add to Calendar button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              ),
              onPressed: () {
                Get.snackbar(
                  "Calendar",
                  "Session added to your Google Calendar!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primary,
                  colorText: Colors.white,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 18.r, color: primary),
                  Spacing.s8.w,
                  Text(
                    "Add to Calendar",
                    style: r14.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s16.h,

            // Return to Sessions Screen
            CustomPrimaryButton(
              text: "Back to Sessions",
              onPressed: () {
                Get.back(); // Closes the Booking screen, returning to Sessions screen which refreshes automatically
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: primary),
        Spacing.s12.w,
        Expanded(
          child: Text(
            text,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
