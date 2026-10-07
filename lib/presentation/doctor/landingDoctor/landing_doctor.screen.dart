import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/presentation/doctor/appointmentDoctor/views/doctor_appointments.view.dart';
import 'package:Mentora/presentation/doctor/dashboardDoctor/views/doctor_dashboard.view.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/landing_doctor.controller.dart';
import 'views/doctor_patients.view.dart';
import 'views/doctor_profile_settings.view.dart';
import 'views/doctor_schedule.view.dart';
import 'views/doctor_sidebar.view.dart';
import 'views/doctor_top_appbar.view.dart';

class LandingDoctorScreen extends GetView<LandingDoctorController> {
  LandingDoctorScreen({super.key});

  @override
  final controller = Get.put(LandingDoctorController());

  @override
  Widget build(BuildContext context) {
    // Listen for resize
    MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 768;

        return CustomScreenWrapper(
          safeAreaTop: true,
          scaffoldKey: controller.scaffoldKey,
          drawer: isWideScreen
              ? null
              : const Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: DoctorSidebarView(isDrawer: true),
                ),
          body: Row(
            children: [
              if (isWideScreen) const DoctorSidebarView(),
              Expanded(child: buildMainArea(context, isWideScreen)),
            ],
          ),
        );
      },
    );
  }

  Widget buildMainArea(BuildContext context, bool isWideScreen) {
    return Column(
      children: [
        DoctorTopAppbarView(isWideScreen: isWideScreen),
        Expanded(child: buildContentBody(context)),
      ],
    );
  }

  Widget buildContentBody(BuildContext context) {
    return Obx(() {
      final index = controller.selectedMenuIndex.value;
      switch (index) {
        case 0:
          return const DoctorDashboardView();
        case 1:
          return const DoctorAppointmentsView();
        case 2:
          return const DoctorPatientsView();
        case 3:
          return const DoctorScheduleView();
        case 4:
          return const DoctorProfileSettingsView();
        default:
          return const DoctorDashboardView();
      }
    });
  }
}
