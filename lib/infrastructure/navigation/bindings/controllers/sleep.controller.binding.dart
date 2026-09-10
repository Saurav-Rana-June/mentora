import 'package:get/get.dart';

import '../../../../presentation/app/sleep/controllers/sleep.controller.dart';

class SleepControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepController>(() => SleepController());
  }
}
