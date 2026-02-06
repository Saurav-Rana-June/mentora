import 'package:get/get.dart';

class InsightsController extends GetxController {
  final selectedIndex = 0.obs;

  void toggleGrowthArea(int index) {
    selectedIndex.value = index;
  }
}
