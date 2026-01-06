import 'package:get/get.dart';

import '../../../../presentation/continue/controllers/continue.controller.dart';

class ContinueControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContinueController>(
      () => ContinueController(),
    );
  }
}
