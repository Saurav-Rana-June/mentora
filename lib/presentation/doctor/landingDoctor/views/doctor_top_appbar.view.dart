import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import '../controllers/landing_doctor.controller.dart';

class DoctorTopAppbarView extends GetView<LandingDoctorController> {
  final bool isWideScreen;

  const DoctorTopAppbarView({super.key, required this.isWideScreen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F1D) : white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isWideScreen) ...[
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: controller.openDrawer,
                  tooltip: 'Open Menu',
                ),
                Spacing.s8.w,
              ],
              Obx(() {
                final index = controller.selectedMenuIndex.value;
                final title = controller.menuItems[index].title;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.headlineLarge?.color,
                      ),
                    ),
                    Text(
                      'Mentora Doctors Console',
                      style: r10.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                );
              }),
            ],
          ),
          Row(
            children: [
              DoctorBadge(
                text: 'TELEHEALTH READY',
                icon: '\u{f03d}',
                color: primary,
              ),
              Spacing.s12.w,
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  Get.snackbar(
                    'Clinical Notifications',
                    'You have 4 appointments scheduled for today.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                tooltip: 'Notifications',
              ),
              Spacing.s8.w,
              CircleAvatar(
                radius: 16.r,
                backgroundColor: primary.withValues(alpha: 0.15),
                child: Text(
                  '\u{f0f0}',
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 12,
                    color: primary,
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
