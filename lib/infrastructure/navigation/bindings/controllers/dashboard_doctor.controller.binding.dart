import 'package:get/get.dart';
import 'package:Mentora/presentation/doctor/dashboardDoctor/controllers/dashboard_doctor.controller.dart';

class DashboardDoctorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardDoctorController>(
      () => DashboardDoctorController(),
    );
  }
}
