import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';

class AppUtils {
  static Color getMoodColor(String feeling) {
    switch (feeling) {
      case 'Angry':
        return const Color(0xFFF34538); // red
      case 'Not Good':
        return const Color(0xFFFF991C); // orange
      case 'Normal':
        return const Color(0xFF6CAAD8); // blue
      case 'Good':
        return const Color(0xFF8DC255); // lightGreen
      case 'Very Good':
        return const Color(0xFF49AF58); // darkGreen
      default:
        return const Color(0xFFA5C67C); // primary
    }
  }

  /// Parses common API error JSON shapes for user-visible messages.
  static String? messageFromApiErrorBody(dynamic data) {
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      final msg =
          m['message'] ??
          m['error'] ??
          m['errorMessage'] ??
          m['error_message'] ??
          m['detail'];
      if (msg != null && msg.toString().trim().isNotEmpty) {
        return msg.toString();
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return messageFromApiErrorBody(decoded);
        }
      } catch (_) {}
    }
    return null;
  }

  static String dioErrorMessage(DioException e) {
    final r = e.response;
    if (r != null) {
      final fromBody = messageFromApiErrorBody(r.data);
      if (fromBody != null && fromBody.isNotEmpty) {
        return fromBody;
      }
      final sc = r.statusCode;
      final sm = r.statusMessage;
      return '${sc ?? ''}${sm != null && sm.isNotEmpty ? ' $sm' : ''}'.trim();
    }
    return e.message?.trim().isNotEmpty == true ? e.message! : 'Network error';
  }

  static void snackbar(
    String title,
    String message,
    SnackBarType type, {
    TextButton? actionButton,
    Duration? duration = const Duration(seconds: 3),
  }) {
    Color color;
    IconData icon;

    switch (type) {
      case SnackBarType.SUCCESS:
        color = successColor;
        icon = CupertinoIcons.checkmark_alt_circle_fill;
        break;
      case SnackBarType.ERROR:
        color = dangerColor;
        icon = CupertinoIcons.clear_circled_solid;
        break;
      case SnackBarType.WARNING:
        color = warningColor;
        icon = CupertinoIcons.exclamationmark_circle_fill;
        break;
      case SnackBarType.INFO:
        color = infoColor;
        icon = CupertinoIcons.info_circle_fill;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: white,
      dismissDirection: DismissDirection.horizontal,
      shouldIconPulse: false,
      duration: duration,
      icon: Icon(icon, color: color, size: 26.0),
      mainButton: actionButton,
      colorText: black,
      margin: const EdgeInsets.all(10.0),
      borderRadius: 0.0,
      leftBarIndicatorColor: color,
      overlayBlur: 0,
      barBlur: 0,
      instantInit: false,
      boxShadows: [
        BoxShadow(
          color: black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Generate random
  static String generateUniqueIdFromText(String input, {int suffixLength = 8}) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_-+=';

    final lowerInput = input.toLowerCase().replaceAll(RegExp(r'\s+'), '');

    String randomSuffix = List.generate(suffixLength, (index) {
      return chars[random.nextInt(chars.length)];
    }).join();

    return '${lowerInput}_$randomSuffix';
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
