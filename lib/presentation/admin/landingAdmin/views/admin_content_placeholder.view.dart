import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/landing_admin.controller.dart';

class AdminContentPlaceholderView extends GetView<LandingAdminController> {
  final AdminMenuItem? menuItem;

  const AdminContentPlaceholderView({super.key, this.menuItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeItem = menuItem ??
        controller.menuItems[controller.selectedMenuIndex.value];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            activeItem.icon,
            style: TextStyle(
              fontFamily: 'FontAwesomeSolid',
              fontSize: 48.spMin,
              color: primary,
            ),
          ),
          Spacing.s16.h,
          Text(
            '${activeItem.title} Management',
            style: h2.copyWith(
              color: theme.textTheme.headlineMedium?.color,
            ),
          ),
          Spacing.s8.h,
          Text(
            'Configure, create, update, and manage ${activeItem.title} for the platform.',
            style: r14.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
