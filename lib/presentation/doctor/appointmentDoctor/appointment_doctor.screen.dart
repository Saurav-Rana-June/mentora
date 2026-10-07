import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/appointment_doctor.controller.dart';
import 'views/doctor_appointments.view.dart';

class AppointmentDoctorScreen extends GetView<AppointmentDoctorController> {
  AppointmentDoctorScreen({super.key});

  @override
  final controller = Get.put(AppointmentDoctorController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      safeAreaTop: true,
      body: const DoctorAppointmentsView(),
    );
  }
}
