import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.awaitSpeakCompletion(true);
      _isInitialized = true;
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  Future<void> speak(
    String text, {
    VoidCallback? onComplete,
    VoidCallback? onError,
    VoidCallback? onCancel,
  }) async {
    await init();
    try {
      _flutterTts.setCompletionHandler(() {
        onComplete?.call();
      });
      _flutterTts.setCancelHandler(() {
        onCancel?.call();
      });
      _flutterTts.setErrorHandler((msg) {
        debugPrint("TTS error: $msg");
        onError?.call();
      });

      final cleanText = _cleanMarkdownForTTS(text);
      if (cleanText.isEmpty) {
        onComplete?.call();
        return;
      }
      await _flutterTts.speak(cleanText);
    } catch (e) {
      debugPrint("TTS speak error: $e");
      onError?.call();
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint("TTS stop error: $e");
    }
  }

  String _cleanMarkdownForTTS(String markdown) {
    return markdown
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1') // Bold
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1') // Italic
        .replaceAll(RegExp(r'#+\s*'), '') // Headers
        .replaceAll(RegExp(r'`+[^`]*`+'), '') // Code blocks / inline code
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1') // Markdown links
        .replaceAll(RegExp(r'[-*•]\s+'), '') // Bullet points
        .replaceAll(RegExp(r'^\s*>\s+', multiLine: true), '') // Blockquotes
        .replaceAll(RegExp(r'\n{2,}'), '\n') // Multiple newlines
        .trim();
  }
}
