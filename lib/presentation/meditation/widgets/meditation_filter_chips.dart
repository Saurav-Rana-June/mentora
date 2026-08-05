import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class MeditationFilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  static const List<String> categories = [
    'All',
    'Sleep',
    'Stress Relief',
    'Anxiety',
    'Focus',
    'Self-Esteem',
    'Kindness',
    'Gratitude',
    'Anger',
    'Grief',
  ];

  const MeditationFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 48.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.toLowerCase() == selectedCategory.toLowerCase();

          return Padding(
            padding: EdgeInsets.only(right: Spacing.s8.value.w),
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s16.symmetric.horizontal,
                  vertical: Spacing.s8.symmetric.vertical,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : (isDark ? slate[800] : white),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? slate[700]! : slate[200]!),
                    width: 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: r14.copyWith(
                      color: isSelected
                          ? white
                          : (isDark ? slate[300] : slate[700]),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    child: Text(category),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
