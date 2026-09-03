import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/buttons/custom_outline_button.widget.dart';

class CustomConfirmationBox extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final Widget? icon;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const CustomConfirmationBox({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.confirmLabel = "Confirm",
    this.cancelLabel = "Cancel",
    this.isDestructive = false,
    this.icon,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors
    final Color effectiveConfirmColor =
        confirmButtonColor ?? (isDestructive ? red : theme.primaryColor);

    final Color effectiveCancelColor =
        cancelButtonColor ?? (isDark ? slate[600]! : slate[300]!);

    return Dialog(
      backgroundColor:
          theme.cardTheme.color ?? (isDark ? slate[800] : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s20.symmetric.horizontal,
          vertical: Spacing.s20.symmetric.vertical,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              Spacing.s16.h,
            ] else if (isDestructive) ...[
              Container(
                height: 54.h,
                width: 54.h,
                decoration: BoxDecoration(
                  color: red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: red,
                    size: 28.sp,
                  ),
                ),
              ),
              Spacing.s16.h,
            ],
            Text(
              title,
              style: h3.copyWith(
                color: theme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.s12.h,
            Text(
              message,
              style: r14.copyWith(
                color: theme.textTheme.bodyMedium!.color,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.s24.h,
            Row(
              children: [
                Expanded(
                  child: CustomOutlineButton(
                    label: cancelLabel,
                    borderColor: effectiveCancelColor,
                    textColor: theme.textTheme.bodyMedium!.color,
                    onTap: onCancel ?? () => Get.back(),
                    height: 44.h,
                    borderRadius: 12.r,
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: CustomPrimaryButton(
                    text: confirmLabel,
                    backgroundColor: effectiveConfirmColor,
                    onPressed: onConfirm,
                    height: 44.h,
                    borderRadius: 12.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
