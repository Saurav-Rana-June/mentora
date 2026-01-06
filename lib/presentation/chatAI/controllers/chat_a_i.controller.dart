import 'package:get/get.dart';

class ChatAIController extends GetxController {
  final RxList<MessageModel> messages = <MessageModel>[
    MessageModel(
      message: "Hi 👋 I’m Mentora. I’m here to listen and support you.",
      isMe: false,
    ),
    MessageModel(message: "Hi… I’m not really sure how to start.", isMe: true),
    MessageModel(
      message:
          "That’s completely okay. Take your time — there’s no pressure here.",
      isMe: false,
    ),
    MessageModel(message: "I’ve been feeling overwhelmed lately.", isMe: true),
    MessageModel(
      message:
          "Thank you for sharing that. Feeling overwhelmed can be really heavy. What’s been weighing on you the most?",
      isMe: false,
    ),
    MessageModel(
      message: "Work and personal things… it all feels like too much.",
      isMe: true,
    ),
    MessageModel(
      message:
          "That sounds exhausting. When everything piles up at once, it can feel impossible to breathe. You’re not alone in this.",
      isMe: false,
    ),
    MessageModel(message: "I just want to feel calm again.", isMe: true),
    MessageModel(
      message:
          "Wanting peace is very human 💙 We can take this one small step at a time. Would you like to talk more, or try a short calming exercise together?",
      isMe: false,
    ),
  ].obs;

  void sendMessage(String text) {
    messages.add(MessageModel(message: text, isMe: true));

    messages.add(
      MessageModel(message: "This is a dummy AI response 🤖", isMe: false),
    );
  }

  RxBool isSearching = false.obs;
}

class MessageModel {
  final String message;
  final bool isMe;

  MessageModel({required this.message, required this.isMe});
}
