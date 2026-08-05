import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';

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
    return SizedBox(
      height: 48.h,
      child: CustomHorizontalScrollableFilter<String>(
        items: categories,
        selectedItem: selectedCategory,
        labelBuilder: (cat) => cat,
        onItemSelected: onCategorySelected,
        padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
      ),
    );
  }
}
