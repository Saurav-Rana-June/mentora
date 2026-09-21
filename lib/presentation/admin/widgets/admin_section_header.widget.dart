import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String? buttonText;
  final VoidCallback? onAddPressed;
  final Widget? filterWidget;
  final VoidCallback? onRefresh;

  const AdminSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.buttonText,
    this.onAddPressed,
    this.filterWidget,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Title and Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                if (subtitle != null) ...[
                  Spacing.s4.h,
                  Text(
                    subtitle!,
                    style: r14.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: theme.textTheme.bodyMedium?.color,
                      size: 20.spMin,
                    ),
                    tooltip: 'Refresh',
                  ),
                if (buttonText != null && onAddPressed != null) ...[
                  Spacing.s12.w,
                  ElevatedButton.icon(
                    onPressed: onAddPressed,
                    icon: Icon(Icons.add_rounded, size: 18.spMin, color: white),
                    label: Text(
                      buttonText!,
                      style: r14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Spacing.s16.h,
        // Search bar & filters
        Row(
          children: [
            if (onSearchChanged != null)
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF242522) : white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                    ),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    style: r14.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: r14.copyWith(color: slate[400]),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20.spMin,
                        color: slate[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                ),
              ),
            if (filterWidget != null) ...[
              Spacing.s12.w,
              filterWidget!,
            ],
          ],
        ),
      ],
    );
  }
}
