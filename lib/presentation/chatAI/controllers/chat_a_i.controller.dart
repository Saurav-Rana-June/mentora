import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/utils/storage_utils.dart';
import '../../../../infrastructure/dal/services/ai_service.dart';
import '../models/chat_session.model.dart';

class ChatAIController extends GetxController {
  final GlobalKey exportKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // All stored chat sessions
  final RxList<ChatSessionModel> sessions = <ChatSessionModel>[].obs;

  // Active chat session
  final Rxn<ChatSessionModel> currentSession = Rxn<ChatSessionModel>();

  // Current session messages (mirrors currentSession.value?.messages)
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController landingScrollController = ScrollController();

  final RxString currentInputText = "".obs;
  final RxString historySearchQuery = "".obs;

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
    _loadSessions();
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

  // --- PERSISTENCE & SESSION MANAGEMENT ---

  void _loadSessions() {
    try {
      final storedData =
          StorageUtils.read<List<dynamic>>(StorageKeys.CHAT_AI_SESSIONS);
      if (storedData != null && storedData.isNotEmpty) {
        final loaded = storedData
            .map(
              (e) => ChatSessionModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
        // Sort by most recently updated
        loaded.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        sessions.assignAll(loaded);
      }

      final currentId =
          StorageUtils.read<String>(StorageKeys.CHAT_AI_CURRENT_SESSION_ID);
      if (currentId != null) {
        final match = sessions.firstWhereOrNull((s) => s.id == currentId);
        if (match != null && match.messages.isNotEmpty) {
          currentSession.value = match;
          messages.assignAll(match.messages);
        }
      }
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }

    // Sync latest from backend in background
    fetchRemoteSessions();
  }

  /// Sync conversation sessions list from backend
  Future<void> fetchRemoteSessions() async {
    try {
      final response = await AIService.fetchSessions();
      if (response != null && response.data != null) {
        sessions.assignAll(response.data!);
        _saveSessions();
      }
    } catch (e) {
      debugPrint('Error fetching remote sessions: $e');
    }
  }

  Future<void> _saveSessions() async {
    try {
      final data = sessions.map((s) => s.toJson()).toList();
      await StorageUtils.write(StorageKeys.CHAT_AI_SESSIONS, data);
      if (currentSession.value != null) {
        await StorageUtils.write(
          StorageKeys.CHAT_AI_CURRENT_SESSION_ID,
          currentSession.value!.id,
        );
      } else {
        await StorageUtils.remove(StorageKeys.CHAT_AI_CURRENT_SESSION_ID);
      }
    } catch (e) {
      debugPrint('Error saving chat sessions: $e');
    }
  }

  /// Create a fresh new chat conversation and reset to landing view
  void createNewChat() {
    currentSession.value = null;
    messages.clear();
    messageController.clear();
    currentInputText.value = "";
    isScrolled.value = false;
    StorageUtils.remove(StorageKeys.CHAT_AI_CURRENT_SESSION_ID);
  }

  /// Select and load a historical session (locally and from backend)
  void selectSession(ChatSessionModel session) async {
    currentSession.value = session;
    messages.assignAll(session.messages);
    messageController.clear();
    currentInputText.value = "";
    isScrolled.value = false;
    StorageUtils.write(StorageKeys.CHAT_AI_CURRENT_SESSION_ID, session.id);
    _scrollToBottom();

    // Load full message history from backend
    try {
      final detailRes = await AIService.fetchSessionDetails(session.id);
      if (detailRes != null && detailRes.data != null) {
        final fullSession = detailRes.data!;
        currentSession.value = fullSession;
        messages.assignAll(fullSession.messages);
        final idx = sessions.indexWhere((s) => s.id == fullSession.id);
        if (idx != -1) {
          sessions[idx] = fullSession;
        }
        _saveSessions();
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Error loading full session messages: $e');
    }
  }

  /// Delete a single chat session
  void deleteSession(String sessionId) {
    sessions.removeWhere((s) => s.id == sessionId);
    _saveSessions();
    AIService.deleteSession(sessionId);
    if (currentSession.value?.id == sessionId) {
      createNewChat();
    }
  }

  /// Clear all saved chat history
  void clearAllHistory() {
    sessions.clear();
    _saveSessions();
    AIService.clearAllSessions();
    createNewChat();
  }

  /// Open the Chat History Drawer from the right side
  void openHistory() {
    historySearchQuery.value = "";
    fetchRemoteSessions();
    scaffoldKey.currentState?.openEndDrawer();
  }

  // --- MESSAGING FLOW ---

  void sendMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    // Check if we need to initialize a new session
    if (currentSession.value == null) {
      final newSession = ChatSessionModel(
        title: _generateSessionTitle(cleanText),
      );
      currentSession.value = newSession;
      sessions.insert(0, newSession);
    } else {
      // Move active session to top of the history list
      sessions.removeWhere((s) => s.id == currentSession.value!.id);
      sessions.insert(0, currentSession.value!);
    }

    final userMsg = MessageModel(message: cleanText, isMe: true);
    messages.add(userMsg);
    currentSession.value!.messages.add(userMsg);
    currentSession.value!.updatedAt = DateTime.now();
    _saveSessions();

    messageController.clear();
    currentInputText.value = "";
    isScrolled.value = false;
    _scrollToBottom();

    // Add a placeholder "Thinking..." message
    final placeholder = MessageModel(message: "Thinking...", isMe: false);
    messages.add(placeholder);
    _scrollToBottom();

    try {
      final response = await AIService.queryAI(
        query: cleanText,
        sessionId: currentSession.value?.id,
        title: currentSession.value?.title,
      );
      messages.remove(placeholder);

      String aiReply = "";
      if (response != null && response.data != null) {
        aiReply = response.data!['response'] as String;
      } else {
        aiReply = "Sorry, I couldn't reach Mentora AI at the moment. Please try again later.";
      }

      final aiMsg = MessageModel(message: aiReply, isMe: false);
      messages.add(aiMsg);
      currentSession.value!.messages.add(aiMsg);
      currentSession.value!.updatedAt = DateTime.now();
      _saveSessions();
    } catch (e) {
      messages.remove(placeholder);
      final errorMsg = MessageModel(
        message: "Sorry, an unexpected error occurred. Please check your internet connection and try again.",
        isMe: false,
      );
      messages.add(errorMsg);
      currentSession.value!.messages.add(errorMsg);
      currentSession.value!.updatedAt = DateTime.now();
      _saveSessions();
    }
    _scrollToBottom();
  }

  String _generateSessionTitle(String prompt) {
    final trimmed = prompt.replaceAll('\n', ' ').trim();
    if (trimmed.toLowerCase().contains("feeling really anxious") ||
        trimmed.toLowerCase().contains("calm down")) {
      return "Calming Anxiety";
    }
    if (trimmed.toLowerCase().contains("breathing exercise")) {
      return "Breathing Exercise";
    }
    if (trimmed.toLowerCase().contains("stress") ||
        trimmed.toLowerCase().contains("overwhelmed")) {
      return "Stress Relief";
    }
    if (trimmed.toLowerCase().contains("mindfulness quote")) {
      return "Mindfulness Quote";
    }
    if (trimmed.length > 32) {
      return '${trimmed.substring(0, 32)}...';
    }
    return trimmed.isEmpty ? "New Conversation" : trimmed;
  }

  void clearChat() {
    if (currentSession.value != null) {
      deleteSession(currentSession.value!.id);
    } else {
      messages.clear();
    }
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
