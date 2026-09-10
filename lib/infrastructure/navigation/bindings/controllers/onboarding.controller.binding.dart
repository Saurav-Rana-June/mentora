import 'package:get/get.dart';

import '../../../../presentation/app/onboarding/controllers/onboarding.controller.dart';

class OnboardingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
