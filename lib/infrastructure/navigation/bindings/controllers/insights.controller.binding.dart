import 'package:get/get.dart';

import '../../../../presentation/app/insights/controllers/insights.controller.dart';

class InsightsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(() => InsightsController());
  }
}
