import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/landing_admin.controller.dart';

class DashboardOverviewView extends GetView<LandingAdminController> {
  const DashboardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
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
          childAspectRatio: 1.9,
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
