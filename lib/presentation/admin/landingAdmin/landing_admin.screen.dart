import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';

import 'controllers/landing_admin.controller.dart';

class LandingAdminScreen extends GetView<LandingAdminController> {
  LandingAdminScreen({super.key});

  @override
  final controller = Get.put(LandingAdminController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      safeAreaTop: true,
      scaffoldKey: controller.scaffoldKey,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 768;

          return Row(
            children: [
              if (isWideScreen) buildSidebar(context),
              Expanded(
                child: buildMainArea(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------- SIDEBAR NAVIGATION ---------------- //

  Widget buildSidebar(BuildContext context) {
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
        vertical: 20.h,
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
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 38.spMin,
                width: 38.spMin,
                child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
              ),
              if (!isCollapsed) ...[
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
            ],
          ),
          if (!isCollapsed)
            IconButton(
              icon: Icon(
                Icons.menu_open_rounded,
                size: 20.spMin,
                color: theme.textTheme.bodyMedium?.color,
              ),
              onPressed: controller.toggleSidebar,
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
    final Color inactiveColor =
        isDark ? const Color(0xFFA3A3A3) : const Color(0xFF525252);

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
        color: isDark
            ? const Color(0xFF191A18)
            : const Color(0xFFF9FAF7),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : slate[200]!,
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

  // ---------------- MAIN CONTENT AREA ---------------- //

  Widget buildMainArea(BuildContext context) {
    return Column(
      children: [
        buildTopAppbar(context),
        Expanded(
          child: buildContentBody(context),
        ),
      ],
    );
  }

  Widget buildTopAppbar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : slate[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (controller.isSidebarCollapsed.value)
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: controller.toggleSidebar,
                ),
              Obx(
                () => Text(
                  controller
                      .menuItems[controller.selectedMenuIndex.value].title,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 6.h,
                ),
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
              Spacing.s16.w,
              Container(
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
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContentBody(BuildContext context) {
    return Obx(() {
      final index = controller.selectedMenuIndex.value;
      if (index == 0) {
        return buildDashboardOverview(context);
      } else {
        final title = controller.menuItems[index].title;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.menuItems[index].icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 48.spMin,
                  color: primary,
                ),
              ),
              Spacing.s16.h,
              Text(
                '$title Management',
                style: h2.copyWith(
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
              Spacing.s8.h,
              Text(
                'Configure, create, update, and manage $title for the platform.',
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  // ---------------- DASHBOARD OVERVIEW ---------------- //

  Widget buildDashboardOverview(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStatCardsGrid(context),
          Spacing.s24.h,
          buildQuickActionsSection(context),
          Spacing.s24.h,
          buildModulesOverviewSection(context),
        ],
      ),
    );
  }

  Widget buildStatCardsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 1000
            ? 4
            : (constraints.maxWidth > 600 ? 2 : 1);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 2.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildStatCard(
              context: context,
              title: 'Total Users',
              value: '1,420',
              badge: '+12% this week',
              icon: '\u{f0c0}', // users
              iconColor: primary,
            ),
            buildStatCard(
              context: context,
              title: 'Guided Meditations',
              value: '24',
              badge: '8 Active Categories',
              icon: '\u{f4b8}', // spa
              iconColor: infoColor,
            ),
            buildStatCard(
              context: context,
              title: 'Sleep Audio Tracks',
              value: '18',
              badge: '3 Story Tracks',
              icon: '\u{f186}', // moon
              iconColor: warningColor,
            ),
            buildStatCard(
              context: context,
              title: 'Verified Doctors',
              value: '12',
              badge: 'Available Now',
              icon: '\u{f0f0}', // user-md
              iconColor: successColor,
            ),
          ],
        );
      },
    );
  }

  Widget buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String badge,
    required String icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: r12.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  value,
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  badge,
                  style: r10.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 20.spMin,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick CMS Actions',
          style: h3.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        Spacing.s12.h,
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            buildQuickActionButton(
              context: context,
              label: 'Add Meditation Session',
              icon: '\u{f4b8}',
              onTap: () => controller.changeMenuIndex(1),
            ),
            buildQuickActionButton(
              context: context,
              label: 'Upload Sleep Sound',
              icon: '\u{f186}',
              onTap: () => controller.changeMenuIndex(2),
            ),
            buildQuickActionButton(
              context: context,
              label: 'Add Breathing Technique',
              icon: '\u{f72e}',
              onTap: () => controller.changeMenuIndex(3),
            ),
            buildQuickActionButton(
              context: context,
              label: 'Add Journal Prompt',
              icon: '\u{f518}',
              onTap: () => controller.changeMenuIndex(4),
            ),
            buildQuickActionButton(
              context: context,
              label: 'Register Doctor / Expert',
              icon: '\u{f0f0}',
              onTap: () => controller.changeMenuIndex(6),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildQuickActionButton({
    required BuildContext context,
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF242522) : const Color(0xFFF6F8F2),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: primary.withValues(alpha: isDark ? 0.2 : 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14.spMin,
                  color: primary,
                ),
              ),
              Spacing.s8.w,
              Text(
                label,
                style: r14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModulesOverviewSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CMS Module Status',
          style: h3.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        Spacing.s12.h,
        CustomPrimaryCard(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                buildModuleRow(
                  context,
                  name: 'Guided Meditations CMS',
                  route: 'POST /api/admin/meditations',
                  status: 'Operational',
                  onManage: () => controller.changeMenuIndex(1),
                ),
                const Divider(),
                buildModuleRow(
                  context,
                  name: 'Sleep & Ambient Sounds CMS',
                  route: 'POST /api/admin/sleep/sounds',
                  status: 'Operational',
                  onManage: () => controller.changeMenuIndex(2),
                ),
                const Divider(),
                buildModuleRow(
                  context,
                  name: 'Breathing Exercises CMS',
                  route: 'POST /api/admin/breathing',
                  status: 'Operational',
                  onManage: () => controller.changeMenuIndex(3),
                ),
                const Divider(),
                buildModuleRow(
                  context,
                  name: 'Journaling Prompts CMS',
                  route: 'POST /api/admin/journaling/questions',
                  status: 'Operational',
                  onManage: () => controller.changeMenuIndex(4),
                ),
                const Divider(),
                buildModuleRow(
                  context,
                  name: 'Doctors & Therapists Directory CMS',
                  route: 'POST /api/admin/doctors',
                  status: 'Operational',
                  onManage: () => controller.changeMenuIndex(6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildModuleRow(
    BuildContext context, {
    required String name,
    required String route,
    required String status,
    required VoidCallback onManage,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: r14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Spacing.s4.h,
              Text(
                route,
                style: r12.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: r10.copyWith(
                    color: successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacing.s12.w,
              TextButton(
                onPressed: onManage,
                child: Text(
                  'Manage',
                  style: r14.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
