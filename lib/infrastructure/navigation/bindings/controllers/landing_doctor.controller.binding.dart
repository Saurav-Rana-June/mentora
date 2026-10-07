import 'package:get/get.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/controllers/appointment_doctor.controller.dart';
import 'package:Mentora/presentation/doctor/dashboardDoctor/controllers/dashboard_doctor.controller.dart';
import 'package:Mentora/presentation/doctor/landingDoctor/controllers/landing_doctor.controller.dart';

class LandingDoctorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingDoctorController>(
      () => LandingDoctorController(),
    );
    Get.lazyPut<DashboardDoctorController>(
      () => DashboardDoctorController(),
    );
    Get.lazyPut<AppointmentDoctorController>(
      () => AppointmentDoctorController(),
    );
  }
}
