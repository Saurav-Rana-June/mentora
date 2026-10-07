import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'doctor_badge.widget.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final VoidCallback? onStartSession;
  final VoidCallback? onCancelSession;
  final VoidCallback? onCompleteSession;
  final VoidCallback? onViewDetails;

  const DoctorAppointmentCard({
    super.key,
    required this.appointment,
    this.onStartSession,
    this.onCancelSession,
    this.onCompleteSession,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final status = appointment.bookingStatus;
    final isUpcoming = status == 'Upcoming';
    final isInProgress = status == 'In Progress';
    final isCompleted = status == 'Completed';
    final isCancelled = status == 'Cancelled' || status == 'Canceled';

    Color statusColor;
    String statusIcon;
    if (isInProgress) {
      statusColor = infoColor;
      statusIcon = '\u{f03d}'; // video
    } else if (isUpcoming) {
      statusColor = successColor;
      statusIcon = '\u{f017}'; // clock
    } else if (isCompleted) {
      statusColor = primary;
      statusIcon = '\u{f00c}'; // check
    } else {
      statusColor = dangerColor;
      statusIcon = '\u{f00d}'; // times
    }

    final isVideo = appointment.modalityType.toLowerCase().contains('video');

    return CustomPrimaryCard(
      onTap: onViewDetails,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Patient Info + Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: CachedNetworkImage(
                    imageUrl: appointment.patientImage,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: primary.withValues(alpha: 0.1),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      color: primary.withValues(alpha: 0.2),
                      child: Center(
                        child: Text(
                          appointment.patientName.isNotEmpty
                              ? appointment.patientName[0].toUpperCase()
                              : 'P',
                          style: h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              appointment.patientName,
                              style: h3.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.headlineMedium?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacing.s8.w,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? slate[800] : slate[100],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '${appointment.patientAge}y • ${appointment.patientGender}',
                              style: r10.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        'Booking #${appointment.id}',
                        style: r12.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                DoctorBadge(
                  text: status.toUpperCase(),
                  icon: statusIcon,
                  color: statusColor,
                ),
              ],
            ),

            Spacing.s12.h,
            Divider(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : slate[200]!,
              height: 1,
            ),
            Spacing.s12.h,

            // Middle Section: Date/Time + Modality + Fee
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF191A18)
                    : const Color(0xFFF9FAF7),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '\u{f073}', // calendar-alt
                          style: TextStyle(
                            fontFamily: 'FontAwesomeSolid',
                            fontSize: 14,
                            color: primary,
                          ),
                        ),
                        Spacing.s8.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.bookingDate,
                                style: r12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              Text(
                                appointment.bookingTimeslot,
                                style: r12.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : slate[300]!,
                  ),
                  Spacing.s12.w,
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          isVideo ? '\u{f03d}' : '\u{f095}', // video or phone
                          style: TextStyle(
                            fontFamily: 'FontAwesomeSolid',
                            fontSize: 14,
                            color: isVideo ? infoColor : warningColor,
                          ),
                        ),
                        Spacing.s8.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.modalityType,
                                style: r12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${appointment.duration} min • \$${appointment.durationCost.toStringAsFixed(0)}',
                                style: r10.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Patient Chief Complaint
            if (appointment.patientIssue.isNotEmpty) ...[
              Spacing.s12.h,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u{f0f1}', // stethoscope
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 12,
                      color: primary,
                    ),
                  ),
                  Spacing.s8.w,
                  Expanded(
                    child: Text(
                      appointment.patientIssue,
                      style: r12.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Cancellation Reason (if cancelled)
            if (isCancelled && appointment.cancellationReason != null) ...[
              Spacing.s8.h,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: dangerColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: dangerColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: dangerColor,
                      size: 14,
                    ),
                    Spacing.s4.w,
                    Expanded(
                      child: Text(
                        'Reason: ${appointment.cancellationReason}',
                        style: r10.copyWith(color: dangerColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action Buttons
            Spacing.s16.h,
            Row(
              children: [
                if (isUpcoming || isInProgress) ...[
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: onStartSession,
                      icon: const Text(
                        '\u{f03d}', // video
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      label: Text(
                        isInProgress ? 'Resume Call' : 'Start Session',
                        style: r12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  Spacing.s8.w,
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: onCancelSession,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: dangerColor,
                        side: BorderSide(
                          color: dangerColor.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'Cancel',
                        style: r12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: dangerColor,
                        ),
                      ),
                    ),
                  ),
                  Spacing.s8.w,
                  IconButton.outlined(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.more_horiz_rounded, size: 18),
                    tooltip: 'Session Details',
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      side: BorderSide(
                        color: isDark ? slate[700]! : slate[300]!,
                      ),
                    ),
                  ),
                ] else if (isCompleted) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewDetails,
                      icon: Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: primary,
                      ),
                      label: Text(
                        'Clinical Summary & Notes',
                        style: r12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primary.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  if (appointment.stars != null) ...[
                    Spacing.s8.w,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: warningColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: warningColor,
                            size: 16,
                          ),
                          Spacing.s4.w,
                          Text(
                            '${appointment.stars}.0',
                            style: r12.copyWith(
                              fontWeight: FontWeight.w700,
                              color: warningColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'View Details',
                        style: r12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
