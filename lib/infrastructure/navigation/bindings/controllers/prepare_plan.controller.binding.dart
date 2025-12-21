import 'package:get/get.dart';

import '../../../../presentation/preparePlan/controllers/prepare_plan.controller.dart';

class PreparePlanControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreparePlanController>(
      () => PreparePlanController(),
    );
  }
}
