import 'package:get/get.dart';

class ChatAIController extends GetxController {
  final RxList<MessageModel> messages = <MessageModel>[
    MessageModel(message: "Hi 👋 I'm Mentora, your AI assistant.", isMe: false),
    MessageModel(message: "Hello! Can you help me with Flutter?", isMe: true),
    MessageModel(message: "Of course! What are you working on?", isMe: false),
    MessageModel(message: "I'm building a chat UI using GetX.", isMe: true),
    MessageModel(
      message: "Great choice 🚀 Let’s make it clean and scalable.",
      isMe: false,
    ),
  ].obs;

  void sendMessage(String text) {
    messages.add(MessageModel(message: text, isMe: true));

    messages.add(
      MessageModel(message: "This is a dummy AI response 🤖", isMe: false),
    );
  }
}

class MessageModel {
  final String message;
  final bool isMe;

  MessageModel({required this.message, required this.isMe});
}
