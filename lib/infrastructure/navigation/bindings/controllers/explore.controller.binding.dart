import 'package:get/get.dart';

import '../../../../presentation/app/explore/controllers/explore.controller.dart';

class ExploreControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}
