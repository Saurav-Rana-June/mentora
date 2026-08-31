import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../infrastructure/dal/services/ai_service.dart';

class ChatAIController extends GetxController {
  final GlobalKey exportKey = GlobalKey();
  
  // Start with empty messages so the landing view shows by default
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController landingScrollController = ScrollController();

  final RxString currentInputText = "".obs;

  RxBool isSearching = false.obs;
  final RxBool isScrolled = false.obs;

  @override
  void onInit() {
    super.onInit();
    messageController.addListener(() {
      currentInputText.value = messageController.text;
    });
    scrollController.addListener(_scrollListener);
    landingScrollController.addListener(_landingScrollListener);
  }

  void _scrollListener() {
    if (scrollController.hasClients) {
      isScrolled.value = scrollController.offset > 5;
    }
  }

  void _landingScrollListener() {
    if (landingScrollController.hasClients) {
      isScrolled.value = landingScrollController.offset > 5;
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    messages.add(MessageModel(message: text, isMe: true));
    messageController.clear();
    currentInputText.value = "";
    isScrolled.value = false;
    _scrollToBottom();

    // Add a placeholder "Thinking..." message
    final placeholder = MessageModel(message: "Thinking...", isMe: false);
    messages.add(placeholder);
    _scrollToBottom();

    try {
      final response = await AIService.queryAI(query: text);
      messages.remove(placeholder);

      if (response != null && response.data != null) {
        final aiMessage = response.data!['response'] as String;
        messages.add(MessageModel(message: aiMessage, isMe: false));
      } else {
        messages.add(
          MessageModel(
            message: "Sorry, I couldn't reach Mentora AI at the moment. Please try again later.",
            isMe: false,
          ),
        );
      }
    } catch (e) {
      messages.remove(placeholder);
      messages.add(
        MessageModel(
          message: "Sorry, an unexpected error occurred. Please check your internet connection and try again.",
          isMe: false,
        ),
      );
    }
    _scrollToBottom();
  }

  void clearChat() {
    messages.clear();
    isScrolled.value = false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    landingScrollController.dispose();
    super.onClose();
  }
}

class MessageModel {
  final String message;
  final bool isMe;

  MessageModel({required this.message, required this.isMe});
}
