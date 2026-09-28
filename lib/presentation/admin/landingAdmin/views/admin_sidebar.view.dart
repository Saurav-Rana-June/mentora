import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/landing_admin.controller.dart';

class AdminSidebarView extends GetView<LandingAdminController> {
  final bool isDrawer;

  const AdminSidebarView({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isDrawer) {
      const drawerWidth = 280.0;
      return Container(
        width: drawerWidth,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F1D) : white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: const Offset(4, 0),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
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

    return Obx(() {
      final isCollapsed = controller.isSidebarCollapsed.value;
      final targetWidth = isCollapsed ? 80.0 : 260.0;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: targetWidth,
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
        child: ClipRect(
          child: OverflowBox(
            minWidth: targetWidth,
            maxWidth: targetWidth,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: targetWidth,
              child: Column(
                children: [
                  buildSidebarHeader(context),
                  Expanded(child: buildSidebarNavList(context)),
                  buildSidebarAdminProfile(context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildSidebarHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isCollapsed = !isDrawer && controller.isSidebarCollapsed.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 20,
        vertical: isCollapsed ? 16 : 20,
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
                  height: 36,
                  width: 36,
                  child: Image.asset(
                    'assets/logos/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Spacing.s12.h,
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 20,
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
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 38,
                        width: 38,
                        child: Image.asset(
                          'assets/logos/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Spacing.s12.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mentora CMS',
                              style: h3.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Admin Console',
                              style: r10.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.s8.w,
                IconButton(
                  icon: Icon(
                    isDrawer ? Icons.close_rounded : Icons.menu_open_rounded,
                    size: 20,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: () {
                    if (isDrawer) {
                      Navigator.of(context).pop();
                    } else {
                      controller.toggleSidebar();
                    }
                  },
                  tooltip: isDrawer ? 'Close drawer' : 'Collapse sidebar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
    );
  }

  Widget buildSidebarNavList(BuildContext context) {
    final isCollapsed = !isDrawer && controller.isSidebarCollapsed.value;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: isCollapsed ? 8 : 12,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];

        return Obx(() {
          final isSelected = controller.selectedMenuIndex.value == index;
          return buildNavItem(context, item, index, isSelected, isCollapsed);
        });
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

    Widget navItemWidget = Material(
      color: isSelected ? activeBg : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () {
          controller.changeMenuIndex(index);
          if (isDrawer) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 14,
            vertical: 11,
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
                  fontSize: 16,
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
                    width: 6,
                    height: 6,
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
    );

    if (isCollapsed) {
      navItemWidget = Tooltip(
        message: item.title,
        waitDuration: const Duration(milliseconds: 300),
        child: navItemWidget,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: navItemWidget,
    );
  }

  Widget buildSidebarAdminProfile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCollapsed = !isDrawer && controller.isSidebarCollapsed.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 10 : 16,
        vertical: 14,
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
                size: 20,
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
                      fontSize: 14,
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
                    size: 18,
                  ),
                  onPressed: controller.logout,
                  tooltip: 'Logout of CMS',
                ),
              ],
            ),
    );
  }
}
