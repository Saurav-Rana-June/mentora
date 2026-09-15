import 'package:get/get.dart';

import '../../../../presentation/global/splash/controllers/splash.controller.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
