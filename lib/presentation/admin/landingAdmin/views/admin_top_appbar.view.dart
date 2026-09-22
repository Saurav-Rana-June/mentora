import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/landing_admin.controller.dart';

class AdminTopAppbarView extends GetView<LandingAdminController> {
  const AdminTopAppbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : slate[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(
                () => controller.isSidebarCollapsed.value
                    ? IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: controller.toggleSidebar,
                      )
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => Text(
                  controller
                      .menuItems[controller.selectedMenuIndex.value]
                      .title,
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: successColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Spacing.s8.w,
                    Text(
                      'API Backend Connected',
                      style: r12.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,
              buildThemeModeButton(context, isDark),
              Spacing.s12.w,
              buildNotificationButton(context, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildThemeModeButton(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Tooltip(
      message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.toggleThemeMode,
          customBorder: const CircleBorder(),
          hoverColor: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.cardColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : slate[200]!,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey<bool>(isDark),
                size: 20.spMin,
                color: isDark
                    ? const Color(0xFFFFB800)
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotificationButton(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Tooltip(
      message: 'Notifications',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          customBorder: const CircleBorder(),
          hoverColor: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.cardColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : slate[200]!,
              ),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 20.spMin,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
