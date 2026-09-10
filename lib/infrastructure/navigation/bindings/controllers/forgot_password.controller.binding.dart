import 'package:get/get.dart';

import '../../../../presentation/app/forgotPassword/controllers/forgot_password.controller.dart';

class ForgotPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
