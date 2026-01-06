import 'dart:async';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(Routes.INTRODUCTION);
    });
  }
}
