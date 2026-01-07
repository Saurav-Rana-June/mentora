import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ChatAIController extends GetxController {
  final GlobalKey exportKey = GlobalKey();
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

  Future<void> exportChat(GlobalKey boundaryKey) async {
    try {
      final boundary =
          boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/chat_export.png');

      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Chat Export'),
      );
    } catch (e) {
      debugPrint('Export failed: $e');
    }
  }
}

class MessageModel {
  final String message;
  final bool isMe;

  MessageModel({required this.message, required this.isMe});
}
