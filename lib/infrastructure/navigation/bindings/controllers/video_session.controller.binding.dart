import 'package:get/get.dart';

import '../../../../presentation/videoSession/controllers/video_session.controller.dart';

class VideoSessionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoSessionController>(
      () => VideoSessionController(),
    );
  }
}
