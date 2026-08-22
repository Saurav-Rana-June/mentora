import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_primary_button.widget.dart';
import '../../widgets/others/custom.primary.card.dart';
import '../bookingSession/controllers/booking_session_controller.dart';

class BookingConfirmationScreen extends GetView<BookingSessionController> {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctor = controller.selectedDoctor.value;
    final doctorName = doctor?.name ?? "Therapist";
    final formattedDate = controller.selectedDate.value != null
        ? controller.formatBookingDate(controller.selectedDate.value!)
        : "";
    final timeStr = controller.selectedTimeSlot.value?.time ?? "";
    final sessionType = controller.selectedSessionType.value;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.close(2);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSuccessHeader(context, doctorName),
                  Spacing.s32.h,
                  if (doctor != null)
                    _buildSuccessDetails(
                      context,
                      doctor,
                      formattedDate,
                      timeStr,
                      sessionType,
                    ),
                  Spacing.s32.h,
                  _buildNextStepsSection(context),
                  Spacing.s40.h,
                  _buildActionButtons(context),
                  Spacing.s24.h,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(BuildContext context, String doctorName) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Multi-circle layered soft success check container
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 96.h,
              width: 96.h,
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 76.h,
              width: 76.h,
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 56.h,
              width: 56.h,
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: successColor,
                  size: 36.r,
                ),
              ),
            ),
          ],
        ),
        Spacing.s24.h,

        // Confirmed heading
        Text(
          "Your session is confirmed!",
          style: h2.copyWith(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Spacing.s8.h,
        // Emotionally reassuring subtext
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
          ),
          child: Text(
            "Your session has been successfully booked. We've notified your therapist and we'll see you at your scheduled time.",
            style: r14.copyWith(
              color: theme.textTheme.bodySmall!.color,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessDetails(
    BuildContext context,
    dynamic doctor,
    String formattedDate,
    String timeStr,
    String sessionType,
  ) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      borderRadius: 16.r,
      padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
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
                      style: r14.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      doctor.speciality ?? "Mental Health Professional",
                      style: r12.copyWith(
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
                      size: 12.r,
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
          // Booking parameters detail rows
          _buildDetailRow(
            context,
            Icons.calendar_today_outlined,
            "Date & Time",
            "$formattedDate • $timeStr",
          ),
          Spacing.s12.h,
          _buildDetailRow(
            context,
            sessionType == "Video Call"
                ? Icons.videocam_outlined
                : Icons.phone_outlined,
            "Session Type",
            "$sessionType • ${controller.selectedDuration.value} mins",
          ),
          Spacing.s12.h,
          _buildDetailRow(
            context,
            Icons.payment_outlined,
            "Total Fee",
            "\$${controller.sessionPrice.value.toStringAsFixed(0)} (Pay at session)",
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's next?",
            style: r14.copyWith(
              color: theme.textTheme.bodyLarge!.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.s12.h,
          _buildNextStepItem(
            context,
            Icons.notifications_active_outlined,
            "You'll receive a reminder notification before your scheduled session starts.",
          ),
          _buildNextStepItem(
            context,
            Icons.laptop_chromebook_rounded,
            "When it's time, join the call directly from the 'Sessions' area of your app.",
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14.r, color: primary),
          ),
          Spacing.s12.w,
          Expanded(
            child: Text(
              text,
              style: r12.copyWith(
                color: theme.textTheme.bodyMedium!.color,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Primary CTA Button (dominating)
        CustomPrimaryButton(
          text: "View My Sessions",
          onPressed: () {
            Get.close(2); // Returns to Sessions screen which refreshes automatically
          },
          height: 48.h,
          borderRadius: 26.r,
          backgroundColor: primary,
          textColor: Colors.white,
        ),
        Spacing.s12.h,

        // Secondary subtle link button
        TextButton(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 15.r,
                color: theme.textTheme.bodySmall!.color,
              ),
              Spacing.s8.w,
              Text(
                "Add to Calendar",
                style: r12.copyWith(
                  color: theme.textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String text,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: primary),
        Spacing.s12.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: r10.copyWith(
                  color: theme.textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacing.s4.h,
              Text(
                text,
                style: r12.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
