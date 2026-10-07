import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class DoctorStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? badge;
  final Color? badgeColor;
  final String icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const DoctorStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.badge,
    this.badgeColor,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 18,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? primary).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: (badgeColor ?? primary).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      badge!,
                      style: r10.copyWith(
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? primary,
                      ),
                    ),
                  ),
              ],
            ),
            Spacing.s12.h,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineMedium?.color,
                    letterSpacing: -0.5,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  title,
                  style: r14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  Spacing.s4.h,
                  Text(
                    subtitle!,
                    style: r12.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
