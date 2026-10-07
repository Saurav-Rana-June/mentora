import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/dashboard_doctor.controller.dart';
import 'views/doctor_dashboard.view.dart';

class DashboardDoctorScreen extends GetView<DashboardDoctorController> {
  DashboardDoctorScreen({super.key});

  @override
  final controller = Get.put(DashboardDoctorController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      safeAreaTop: true,
      body: const DoctorDashboardView(),
    );
  }
}
