import 'package:get/get.dart';

import '../../../../presentation/chatExperts/controllers/chat_experts.controller.dart';

class ChatExpertsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatExpertsController>(
      () => ChatExpertsController(),
    );
  }
}
