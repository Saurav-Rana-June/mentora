import 'package:get/get.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/controllers/appointment_doctor.controller.dart';

class AppointmentDoctorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentDoctorController>(
      () => AppointmentDoctorController(),
    );
  }
}
