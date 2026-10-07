import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'cancel_session.dialog.dart';
import 'start_session_call.dialog.dart';

class AppointmentDetailDialog extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const AppointmentDetailDialog({super.key, required this.appointment});

  static Future<void> show({
    required BuildContext context,
    required DoctorAppointmentModel appointment,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AppointmentDetailDialog(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUpcoming = appointment.bookingStatus == 'Upcoming';
    final isInProgress = appointment.bookingStatus == 'In Progress';
    final isCompleted = appointment.bookingStatus == 'Completed';
    final isCancelled = appointment.bookingStatus == 'Cancelled' || appointment.bookingStatus == 'Canceled';

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: CachedNetworkImage(
                            imageUrl: appointment.patientImage,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const CircleAvatar(child: Icon(Icons.person)),
                          ),
                        ),
                        Spacing.s12.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.patientName,
                                style: h2.copyWith(fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacing.s4.h,
                              Text(
                                '${appointment.patientAge} yrs • ${appointment.patientGender} • ${appointment.patientPhone}',
                                style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Spacing.s16.h,
              Divider(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
                height: 1,
              ),
              Spacing.s16.h,

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Booking Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF181917) : const Color(0xFFF9FAF7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Appointment Status',
                                  style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                                ),
                                DoctorBadge(
                                  text: appointment.bookingStatus.toUpperCase(),
                                  color: isCompleted
                                      ? primary
                                      : (isUpcoming ? successColor : (isInProgress ? infoColor : dangerColor)),
                                ),
                              ],
                            ),
                            Spacing.s8.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Booking Reference', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                                Text('#MN-${appointment.id}', style: r14.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Spacing.s8.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date & Time Slot', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                                Text(
                                  '${appointment.bookingDate} at ${appointment.bookingTimeslot}',
                                  style: r14.copyWith(fontWeight: FontWeight.w600, color: primary),
                                ),
                              ],
                            ),
                            Spacing.s8.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Modality', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                                Text(appointment.modalityType, style: r14.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Spacing.s8.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Duration & Consultation Fee', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                                Text('${appointment.duration} mins • \$${appointment.durationCost.toStringAsFixed(2)}', style: r14.copyWith(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Spacing.s16.h,
                      Text(
                        'Reason for Consultation / Patient Notes',
                        style: r14.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Spacing.s8.h,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF242522) : slate[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          appointment.patientIssue.isNotEmpty
                              ? appointment.patientIssue
                              : 'No specific notes provided by patient prior to consultation.',
                          style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                        ),
                      ),

                      if (appointment.clinicalNotes != null && appointment.clinicalNotes!.isNotEmpty) ...[
                        Spacing.s16.h,
                        Text(
                          'Doctor Clinical Summary',
                          style: r14.copyWith(fontWeight: FontWeight.w700, color: primary),
                        ),
                        Spacing.s8.h,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: isDark ? 0.1 : 0.05),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            appointment.clinicalNotes!,
                            style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                          ),
                        ),
                      ],

                      if (appointment.prescription != null && appointment.prescription!.isNotEmpty) ...[
                        Spacing.s16.h,
                        Text(
                          'Prescribed Recommendations & Exercises',
                          style: r14.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Spacing.s8.h,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF242522) : slate[50],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            appointment.prescription!,
                            style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                          ),
                        ),
                      ],

                      if (isCancelled && appointment.cancellationReason != null) ...[
                        Spacing.s16.h,
                        Text(
                          'Cancellation Record',
                          style: r14.copyWith(fontWeight: FontWeight.w700, color: dangerColor),
                        ),
                        Spacing.s8.h,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: dangerColor.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            appointment.cancellationReason!,
                            style: r14.copyWith(color: dangerColor),
                          ),
                        ),
                      ],

                      if (appointment.review != null && appointment.review!.isNotEmpty) ...[
                        Spacing.s16.h,
                        Text(
                          'Patient Rating & Review',
                          style: r14.copyWith(fontWeight: FontWeight.w700, color: warningColor),
                        ),
                        Spacing.s8.h,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: warningColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: warningColor.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  for (int i = 0; i < (appointment.stars ?? 5); i++)
                                    Icon(Icons.star_rounded, color: warningColor, size: 16),
                                  Spacing.s8.w,
                                  Text(
                                    '${appointment.stars ?? 5}.0 Stars',
                                    style: r12.copyWith(fontWeight: FontWeight.w700, color: warningColor),
                                  ),
                                ],
                              ),
                              Spacing.s4.h,
                              Text(
                                '"${appointment.review}"',
                                style: r14.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
              Spacing.s16.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isUpcoming || isInProgress) ...[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        CancelSessionDialog.show(context: context, appointment: appointment);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: dangerColor,
                        side: BorderSide(color: dangerColor.withValues(alpha: 0.5)),
                      ),
                      child: const Text('Cancel Session'),
                    ),
                    Spacing.s12.w,
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        StartSessionCallDialog.show(context: context, appointment: appointment);
                      },
                      icon: const Text(
                        '\u{f03d}',
                        style: TextStyle(fontFamily: 'FontAwesomeSolid', color: Colors.white, fontSize: 12),
                      ),
                      label: const Text('Launch Telehealth Session'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
