import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import 'package:Mentora/data/model/doctor_availability.model.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final ValueChanged<TimeSlot> onSlotSelected;

  const TimeSlotSelector({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final morningSlots = slots.where((s) => s.period == "Morning").toList();
    final afternoonSlots = slots.where((s) => s.period == "Afternoon").toList();
    final eveningSlots = slots.where((s) => s.period == "Evening").toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morningSlots.isNotEmpty) ...[
          _buildPeriodSection(context, "Morning", morningSlots),
          Spacing.s16.h,
        ],
        if (afternoonSlots.isNotEmpty) ...[
          _buildPeriodSection(context, "Afternoon", afternoonSlots),
          Spacing.s16.h,
        ],
        if (eveningSlots.isNotEmpty) ...[
          _buildPeriodSection(context, "Evening", eveningSlots),
        ],
      ],
    );
  }

  Widget _buildPeriodSection(
    BuildContext context,
    String title,
    List<TimeSlot> periodSlots,
  ) {
    final theme = Theme.of(context);
    final String periodIcon = title == "Morning"
        ? "☀️"
        : title == "Afternoon"
        ? "🌤️"
        : "🌙";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(periodIcon, style: TextStyle(fontSize: 16.sp)),
            Spacing.s8.w,
            Text(
              title,
              style: r14.copyWith(
                color: theme.textTheme.bodyMedium!.color!.withValues(
                  alpha: 0.8,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.s8.h,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: periodSlots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final slot = periodSlots[index];
            final isSelected =
                selectedSlot != null && selectedSlot!.time == slot.time;
            final isAvailable = slot.isAvailable;

            return InkWell(
              onTap: isAvailable ? () => onSlotSelected(slot) : null,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : isAvailable
                      ? primary.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : isAvailable
                        ? theme.dividerColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    slot.time,
                    style: r12.copyWith(
                      color: isSelected
                          ? white
                          : isAvailable
                          ? theme.textTheme.bodyMedium!.color
                          : theme.textTheme.bodySmall!.color!.withValues(
                              alpha: 0.5,
                            ),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      decoration: isAvailable
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
