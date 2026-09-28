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

  static String getMoodImage(String feeling) {
    switch (feeling) {
      case 'Angry':
        return "assets/moods/Angry Face.svg";
      case 'Not Good':
        return "assets/moods/Not Good Face.svg";
      case 'Normal':
        return "assets/moods/Normal Face.svg";
      case 'Good':
        return "assets/moods/Happy Face.svg";
      case 'Very Good':
        return "assets/moods/Very Happy Face.svg";
      default:
        return "";
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

    final isDark = Get.isDarkMode;
    final bgColor = isDark ? const Color(0xFF232421) : white;
    final titleColor = isDark ? white : (slate[900] ?? Colors.black87);
    final messageColor = isDark
        ? (slate[300] ?? Colors.white70)
        : (slate[600] ?? Colors.black54);
    final borderColor = isDark
        ? (slate[700] ?? const Color(0xFF404040))
        : (slate[200] ?? const Color(0xFFE5E5E5));

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      dismissDirection: DismissDirection.horizontal,
      shouldIconPulse: false,
      duration: duration,
      icon: Container(
        margin: const EdgeInsets.only(left: 4.0, right: 6.0),
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.22 : 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20.0),
      ),
      titleText: Text(
        title,
        style: r16.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
          letterSpacing: -0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      messageText: Text(
        message,
        style: r14.copyWith(color: messageColor, height: 1.25),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      mainButton: actionButton,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      borderRadius: 14.0,
      borderWidth: 1.0,
      borderColor: borderColor,
      overlayBlur: 0,
      barBlur: 0,
      instantInit: false,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.45)
              : (slate[900] ?? Colors.black).withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 8),
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
