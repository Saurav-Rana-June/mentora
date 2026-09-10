import 'package:get/get.dart';

import '../../../../presentation/app/introduction/controllers/introduction.controller.dart';

class IntroductionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionController>(() => IntroductionController());
  }
}
