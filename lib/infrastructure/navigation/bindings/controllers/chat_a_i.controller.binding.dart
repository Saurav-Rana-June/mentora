import 'package:get/get.dart';

import '../../../../presentation/chatAI/controllers/chat_a_i.controller.dart';

class ChatAIControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatAIController>(
      () => ChatAIController(),
    );
  }
}
