import 'package:get/get.dart';

import '../../../../presentation/insights/controllers/insights.controller.dart';

class InsightsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(() => InsightsController());
  }
}
