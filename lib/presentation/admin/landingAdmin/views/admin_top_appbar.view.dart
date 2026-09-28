import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/landing_admin.controller.dart';

class AdminTopAppbarView extends GetView<LandingAdminController> {
  final bool isWideScreen;

  const AdminTopAppbarView({super.key, this.isWideScreen = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = AppScale.isMobile || !isWideScreen;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
      ),
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
          // Left side: Menu button & Title
          Expanded(
            child: Row(
              children: [
                if (!isWideScreen)
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () {
                      controller.scaffoldKey.currentState?.openDrawer();
                    },
                    tooltip: 'Open navigation menu',
                  )
                else
                  Obx(
                    () => controller.isSidebarCollapsed.value
                        ? IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: controller.toggleSidebar,
                            tooltip: 'Expand sidebar',
                          )
                        : const SizedBox.shrink(),
                  ),
                Spacing.s4.w,
                Expanded(
                  child: Obx(
                    () => Text(
                      controller
                          .menuItems[controller.selectedMenuIndex.value]
                          .title,
                      style: (isMobile ? h3 : h2).copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.headlineMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.s8.w,
          // Right side: Status, Theme & Notifications
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMobile)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: successColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacing.s8.w,
                      Text(
                        'API Connected',
                        style: r12.copyWith(
                          color: successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Tooltip(
                  message: 'API Backend Connected',
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: successColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              Spacing.s8.w,
              buildThemeModeButton(context, isDark),
              Spacing.s8.w,
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
            padding: const EdgeInsets.all(8),
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
                size: 18,
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
            padding: const EdgeInsets.all(8),
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
              size: 18,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
