import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/landing_admin.controller.dart';
import 'views/admin_content_placeholder.view.dart';
import 'views/admin_sidebar.view.dart';
import 'views/admin_top_appbar.view.dart';
import 'views/dashboard_overview.view.dart';

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
              if (isWideScreen) const AdminSidebarView(),
              Expanded(child: buildMainArea(context)),
            ],
          );
        },
      ),
    );
  }

  Widget buildMainArea(BuildContext context) {
    return Column(
      children: [
        const AdminTopAppbarView(),
        Expanded(child: buildContentBody(context)),
      ],
    );
  }

  Widget buildContentBody(BuildContext context) {
    return Obx(() {
      final index = controller.selectedMenuIndex.value;
      if (index == 0) {
        return const DashboardOverviewView();
      } else {
        return AdminContentPlaceholderView(
          menuItem: controller.menuItems[index],
        );
      }
    });
  }
}
