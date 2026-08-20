import 'package:Mentora/data/model/expert.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.divider.dart';
import 'package:Mentora/presentation/bookingSession/models/booking_session_model.dart';

class BookingSummaryCard extends StatelessWidget {
  final Expert expert;
  final DateTime date;
  final TimeSlot timeSlot;
  final String sessionType;
  final String notes;

  const BookingSummaryCard({
    super.key,
    required this.expert,
    required this.date,
    required this.timeSlot,
    required this.sessionType,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPrimaryCard(
      borderRadius: 16.r,
      padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Therapist row
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(expert.image ?? ''),
                backgroundColor: theme.primaryColorLight,
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert.name ?? 'Therapist',
                      style: r16.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      expert.speciality ?? 'Specialist',
                      style: r12.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,
          const CustomDivider(),
          Spacing.s16.h,

          // Details grid/rows
          _buildSummaryRow(
            context,
            Icons.calendar_today_outlined,
            "Date",
            _formatFullDate(date),
          ),
          Spacing.s12.h,
          _buildSummaryRow(context, Icons.access_time, "Time", timeSlot.time),
          Spacing.s12.h,
          _buildSummaryRow(
            context,
            sessionType == "Video Call"
                ? Icons.videocam_outlined
                : Icons.phone_outlined,
            "Session Type",
            sessionType,
          ),
          Spacing.s12.h,
          _buildSummaryRow(
            context,
            Icons.access_time,
            "Duration",
            "50 minutes",
          ),
          Spacing.s12.h,
          _buildSummaryRow(
            context,
            Icons.payments_outlined,
            "Session Fee",
            "₹1,500",
            valueColor: primary,
            valueWeight: FontWeight.w700,
          ),

          if (notes.trim().isNotEmpty) ...[
            Spacing.s16.h,
            const CustomDivider(),
            Spacing.s16.h,
            Text(
              "Your Notes",
              style: r12.copyWith(
                color: theme.textTheme.bodySmall!.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.s8.h,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.primaryColorLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                notes,
                style: r14.copyWith(
                  color: theme.textTheme.bodyMedium!.color,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18.r, color: primary),
        Spacing.s12.w,
        Text(
          label,
          style: r14.copyWith(
            color: theme.textTheme.bodySmall!.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: r14.copyWith(
            color: valueColor ?? theme.textTheme.bodyLarge!.color,
            fontWeight: valueWeight ?? FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatFullDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }
}
