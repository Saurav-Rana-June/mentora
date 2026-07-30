import 'package:get/get.dart';

import '../../../../presentation/sleep/controllers/sleep.controller.dart';

class SleepControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepController>(
      () => SleepController(),
    );
  }
}
