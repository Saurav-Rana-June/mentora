import 'package:get/get.dart';

import '../../../../presentation/allSet/controllers/all_set.controller.dart';

class AllSetControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllSetController>(
      () => AllSetController(),
    );
  }
}
