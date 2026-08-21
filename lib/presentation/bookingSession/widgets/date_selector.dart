import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal +
                Spacing.s4.symmetric.horizontal,
          ),
          child: Text(
            "Select Date",
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacing.s12.h,
        SizedBox(
          height: 72.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal +
                  Spacing.s4.symmetric.horizontal,
            ),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSameDay =
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

              final String weekday = _getWeekdayLetter(date);
              final String dayNum = date.day.toString();

              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: InkWell(
                  onTap: () => onDateSelected(date),
                  borderRadius: BorderRadius.circular(16.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 54.w,
                    decoration: BoxDecoration(
                      color: isSameDay
                          ? primary
                          : primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSameDay
                            ? primary
                            : Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekday,
                          style: r12.copyWith(
                            color: isSameDay
                                ? white
                                : Theme.of(context).textTheme.bodySmall!.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.s4.h,
                        Text(
                          dayNum,
                          style: r18.copyWith(
                            color: isSameDay
                                ? white
                                : Theme.of(context).textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getWeekdayLetter(DateTime date) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }
}
