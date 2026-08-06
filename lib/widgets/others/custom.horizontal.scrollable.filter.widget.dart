import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'custom.pill.widget.dart';

class CustomHorizontalScrollableFilter<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onItemSelected;
  final EdgeInsetsGeometry? padding;

  const CustomHorizontalScrollableFilter({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    required this.onItemSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Spacing.s8.value.w,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = selectedItem == item;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CustomPill(
              label: labelBuilder(item),
              isSelected: isSelected,
              onTap: () => onItemSelected(item),
            ),
          );
        }).toList(),
      ),
    );
  }
}
