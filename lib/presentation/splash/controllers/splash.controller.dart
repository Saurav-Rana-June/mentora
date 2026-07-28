import 'dart:async';

import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      final token = AppMethod.getUserToken();
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.LANDING);
      } else {
        Get.offAllNamed(Routes.INTRODUCTION);
      }
    });
  }
}
