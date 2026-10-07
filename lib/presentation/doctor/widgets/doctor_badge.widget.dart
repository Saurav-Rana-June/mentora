import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class DoctorBadge extends StatelessWidget {
  final String text;
  final String? icon;
  final Color? color;
  final bool isSolid;

  const DoctorBadge({
    super.key,
    required this.text,
    this.icon,
    this.color,
    this.isSolid = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSolid
            ? effectiveColor
            : effectiveColor.withValues(alpha: isDark ? 0.16 : 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: isSolid
            ? null
            : Border.all(
                color: effectiveColor.withValues(alpha: 0.3),
                width: 1,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(
              icon!,
              style: TextStyle(
                fontFamily: 'FontAwesomeSolid',
                fontSize: 10,
                color: isSolid ? white : effectiveColor,
              ),
            ),
            Spacing.s4.w,
          ],
          Text(
            text,
            style: r10.copyWith(
              fontWeight: FontWeight.w700,
              color: isSolid ? white : effectiveColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
