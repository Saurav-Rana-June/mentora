import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class PlayerBottomActions extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;

  const PlayerBottomActions({
    super.key,
    required this.isFavorited,
    this.onFavoriteTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? slate[300] : slate[700];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s40.value.w,
        vertical: Spacing.s20.value.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Download (Disabled Placeholder)
          IconButton(
            onPressed: () {
              Get.snackbar(
                "Premium Feature",
                "Downloading guided sessions is available on Premium plans.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: isDark ? slate[900]!.withValues(alpha: 0.9) : white.withValues(alpha: 0.9),
                colorText: Theme.of(context).textTheme.bodyLarge!.color,
                margin: EdgeInsets.all(Spacing.s16.value),
                borderRadius: 12.r,
              );
            },
            icon: Opacity(
              opacity: 0.35,
              child: Text(
                '\u{f019}', // download
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 20.sp,
                  color: iconColor,
                ),
              ),
            ),
            tooltip: "Download (Premium)",
          ),

          // Share
          IconButton(
            onPressed: onShareTap ?? () {
              Get.snackbar(
                "Share",
                "Sharing session link...",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: isDark ? slate[900]!.withValues(alpha: 0.9) : white.withValues(alpha: 0.9),
                colorText: Theme.of(context).textTheme.bodyLarge!.color,
                margin: EdgeInsets.all(Spacing.s16.value),
                borderRadius: 12.r,
              );
            },
            icon: Text(
              '\u{f1e0}', // share
              style: TextStyle(
                fontFamily: 'FontAwesomeSolid',
                fontSize: 20.sp,
                color: iconColor,
              ),
            ),
            tooltip: "Share",
          ),

          // Favorite (Toggleable)
          IconButton(
            onPressed: onFavoriteTap,
            icon: Text(
              isFavorited ? '\u{f004}' : '\u{f004}', // heart icon
              style: TextStyle(
                fontFamily: isFavorited ? 'FontAwesomeSolid' : 'FontAwesomeLight',
                fontSize: 20.sp,
                color: isFavorited ? red : iconColor,
              ),
            ),
            tooltip: "Favorite",
          ),
        ],
      ),
    );
  }
}
