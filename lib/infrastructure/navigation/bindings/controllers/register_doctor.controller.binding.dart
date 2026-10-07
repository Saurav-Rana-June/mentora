import 'package:get/get.dart';
import 'package:Mentora/presentation/doctor/registerDoctor/controllers/register_doctor.controller.dart';

class RegisterDoctorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterDoctorController>(
      () => RegisterDoctorController(),
    );
  }
}
