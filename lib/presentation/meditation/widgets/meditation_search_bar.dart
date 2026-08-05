import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class MeditationSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const MeditationSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.value.w,
        vertical: Spacing.s8.value.h,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: r16.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        decoration: InputDecoration(
          hintText: "Search meditations...",
          hintStyle: r14.copyWith(
            color: slate[400],
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Spacing.s16.value.w, right: Spacing.s12.value.w),
            child: Icon(
              Icons.search,
              size: 22.sp,
              color: isDark ? slate[300] : slate[500],
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          filled: true,
          fillColor: isDark ? slate[800] : white,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: primary.withValues(alpha: 0.5), width: 1.5),
          ),
        ),
      ),
    );
  }
}
