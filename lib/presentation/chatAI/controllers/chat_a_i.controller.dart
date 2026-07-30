import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(MessageModel(message: text, isMe: true));
    messageController.clear();
    currentInputText.value = "";
    isScrolled.value = false;
    _scrollToBottom();

    // Simulate AI thinking and replying with a natural delay
    Future.delayed(const Duration(milliseconds: 600), () {
      messages.add(
        MessageModel(
          message: "Thank you for sharing that. Mentora is here to support you. Let's take it one step at a time. Tell me a bit more about how you're feeling?",
          isMe: false,
        ),
      );
      _scrollToBottom();
    });
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
