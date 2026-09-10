import 'package:get/get.dart';

import '../../../../presentation/app/signUp/controllers/sign_up.controller.dart';

class SignUpControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
