import 'package:get/get.dart';
import 'package:Mentora/presentation/doctor/loginDoctor/controllers/login_doctor.controller.dart';

class LoginDoctorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginDoctorController>(
      () => LoginDoctorController(),
    );
  }
}
