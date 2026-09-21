import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import '../activityAdmin/admin_activity.view.dart';
import '../breathingAdmin/admin_breathing.view.dart';
import '../doctorAdmin/admin_doctor.view.dart';
import '../journalingAdmin/admin_journaling.view.dart';
import '../meditationAdmin/admin_meditations.view.dart';
import '../settingsAdmin/admin_settings.view.dart';
import '../sleepAdmin/admin_sleep.view.dart';
import '../videoSessionAdmin/admin_video_session.view.dart';
import 'controllers/landing_admin.controller.dart';
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
      switch (index) {
        case 0:
          return const DashboardOverviewView();
        case 1:
          return const AdminMeditationsView();
        case 2:
          return const AdminSleepView();
        case 3:
          return const AdminBreathingView();
        case 4:
          return const AdminJournalingView();
        case 5:
          return const AdminVideoSessionView();
        case 6:
          return const AdminDoctorView();
        case 7:
          return const AdminActivityView();
        case 8:
          return const AdminSettingsView();
        default:
          return const DashboardOverviewView();
      }
    });
  }
}
