import 'package:get/get.dart';

import '../../../../presentation/app/moodCheckin/controllers/mood_checkin.controller.dart';

class MoodCheckinControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodCheckinController>(() => MoodCheckinController());
  }
}
