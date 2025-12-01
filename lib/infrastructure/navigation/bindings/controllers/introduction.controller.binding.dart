import 'package:get/get.dart';

import '../../../../presentation/introduction/controllers/introduction.controller.dart';

class IntroductionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionController>(
      () => IntroductionController(),
    );
  }
}
