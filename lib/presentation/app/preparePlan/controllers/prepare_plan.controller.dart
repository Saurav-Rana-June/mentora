import 'package:get/get.dart';

class PreparePlanController extends GetxController {
  RxInt progressCount = 0.obs;

  @override
  void onInit() {
    onGoingProgress();
    super.onInit();
  }

  void onGoingProgress() {
    for (int i = 0; i <= 100; i++) {
      progressCount.value = i;
    }
  }
}
