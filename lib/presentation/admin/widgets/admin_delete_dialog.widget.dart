import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class AdminDeleteDialog extends StatefulWidget {
  final String title;
  final String message;
  final String itemName;
  final Future<void> Function() onConfirm;

  const AdminDeleteDialog({
    super.key,
    this.title = 'Confirm Deletion',
    this.message = 'Are you sure you want to delete this item? This action cannot be undone.',
    required this.itemName,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    String title = 'Confirm Deletion',
    String message = 'Are you sure you want to delete this item? This action cannot be undone.',
    required String itemName,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminDeleteDialog(
        title: title,
        message: message,
        itemName: itemName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AdminDeleteDialog> createState() => _AdminDeleteDialogState();
}

class _AdminDeleteDialogState extends State<AdminDeleteDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: 440.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: dangerColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: dangerColor,
                    size: 24.spMin,
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Text(
                    widget.title,
                    style: h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.s16.h,
            Text(
              widget.message,
              style: r14.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            Spacing.s12.h,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282926) : const Color(0xFFF6F8F2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : slate[200]!,
                ),
              ),
              child: Text(
                widget.itemName,
                style: r14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.s24.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Get.back(result: false),
                  child: Text(
                    'Cancel',
                    style: r14.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacing.s12.w,
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            await widget.onConfirm();
                            Get.back(result: true);
                          } catch (_) {
                            setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Delete',
                          style: r14.copyWith(
                            color: white,
                            fontWeight: FontWeight.w600,
                          ),
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
