import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/landing_admin.controller.dart';

class AdminSidebarView extends GetView<LandingAdminController> {
  const AdminSidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: controller.isSidebarCollapsed.value ? 80.w : 260.w,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F1D) : white,
          border: Border(
            right: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : slate[200]!,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(2, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            buildSidebarHeader(context),
            Expanded(child: buildSidebarNavList(context)),
            buildSidebarAdminProfile(context),
          ],
        ),
      ),
    );
  }

  Widget buildSidebarHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isCollapsed = controller.isSidebarCollapsed.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12.w : 20.w,
        vertical: isCollapsed ? 16.h : 20.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.06)
                : slate[200]!,
          ),
        ),
      ),
      child: isCollapsed
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 36.spMin,
                  width: 36.spMin,
                  child: Image.asset(
                    'assets/logos/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Spacing.s12.h,
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 20.spMin,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: controller.toggleSidebar,
                  tooltip: 'Expand sidebar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 38.spMin,
                      width: 38.spMin,
                      child: Image.asset(
                        'assets/logos/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Spacing.s12.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mentora CMS',
                          style: h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.headlineLarge?.color,
                          ),
                        ),
                        Text(
                          'Admin Console',
                          style: r10.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu_open_rounded,
                    size: 20.spMin,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: controller.toggleSidebar,
                  tooltip: 'Collapse sidebar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
    );
  }

  Widget buildSidebarNavList(BuildContext context) {
    final isCollapsed = controller.isSidebarCollapsed.value;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: isCollapsed ? 8.w : 12.w,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];
        final isSelected = controller.selectedMenuIndex.value == index;

        return buildNavItem(context, item, index, isSelected, isCollapsed);
      },
    );
  }

  Widget buildNavItem(
    BuildContext context,
    AdminMenuItem item,
    int index,
    bool isSelected,
    bool isCollapsed,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color activeBg = primary.withValues(alpha: isDark ? 0.2 : 0.12);
    final Color activeColor = primary;
    final Color inactiveColor = isDark
        ? const Color(0xFFA3A3A3)
        : const Color(0xFF525252);

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      child: Material(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () => controller.changeMenuIndex(index),
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12.w : 14.w,
              vertical: 11.h,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  item.icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 16.spMin,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
                if (!isCollapsed) ...[
                  Spacing.s12.w,
                  Expanded(
                    child: Text(
                      item.title,
                      style: r14.copyWith(
                        color: isSelected
                            ? (isDark ? white : const Color(0xFF171717))
                            : inactiveColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSidebarAdminProfile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCollapsed = controller.isSidebarCollapsed.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 10.w : 16.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191A18) : const Color(0xFFF9FAF7),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : slate[200]!,
          ),
        ),
      ),
      child: isCollapsed
          ? IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: dangerColor,
                size: 20.spMin,
              ),
              onPressed: controller.logout,
              tooltip: 'Logout',
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: primary.withValues(alpha: 0.2),
                  child: Text(
                    '\u{f4fe}', // user-shield
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 14.spMin,
                      color: primary,
                    ),
                  ),
                ),
                Spacing.s8.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Text(
                          controller.adminEmail.value,
                          style: r12.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Portal Administrator',
                        style: r10.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: isDark ? slate[400] : slate[600],
                    size: 18.spMin,
                  ),
                  onPressed: controller.logout,
                  tooltip: 'Logout of CMS',
                ),
              ],
            ),
    );
  }
}
