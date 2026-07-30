import 'package:get/get.dart';

import '../../../../presentation/signIn/controllers/sign_in.controller.dart';

class SignInControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(),
    );
  }
}
