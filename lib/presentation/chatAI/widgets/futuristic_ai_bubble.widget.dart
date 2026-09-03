import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/chat_a_i.controller.dart';
import '../models/chat_session.model.dart';

class FuturisticAiBubble extends StatelessWidget {
  final MessageModel message;
  final int index;
  final ChatAIController controller;

  const FuturisticAiBubble({
    super.key,
    required this.message,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isThinking = message.message == "Thinking...";

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: Spacing.s16.symmetric.horizontal),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Futuristic AI Avatar with animated ambient glow
            FuturisticAiAvatar(isThinking: isThinking, controller: controller, messageId: message.id),
            Spacing.s8.w,
            // Bubble Content
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 0.78.sw),
                child: isThinking
                    ? FuturisticAiThinkingCard(theme: theme)
                    : FuturisticAiMessageCard(
                        message: message,
                        index: index,
                        controller: controller,
                        theme: theme,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Futuristic Animated AI Avatar with glowing pulses
class FuturisticAiAvatar extends StatefulWidget {
  final bool isThinking;
  final ChatAIController controller;
  final String messageId;

  const FuturisticAiAvatar({
    super.key,
    required this.isThinking,
    required this.controller,
    required this.messageId,
  });

  @override
  State<FuturisticAiAvatar> createState() => _FuturisticAiAvatarState();
}

class _FuturisticAiAvatarState extends State<FuturisticAiAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSpeaking =
          widget.controller.currentlySpeakingMessageId.value == widget.messageId;
      final shouldAnimate = widget.isThinking || isSpeaking;

      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final animValue = shouldAnimate ? _pulseAnimation.value : 0.0;
          final glowRadius = 8.0 + (animValue * 10.0);
          final glowOpacity = 0.2 + (animValue * 0.35);

          return Container(
            height: 34.h,
            width: 34.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withValues(alpha: 0.25 + (animValue * 0.2)),
                  primary.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: primary.withValues(
                  alpha: 0.4 + (animValue * 0.5),
                ),
                width: 1.2 + (animValue * 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: glowOpacity),
                  blurRadius: glowRadius,
                  spreadRadius: animValue * 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '\u{f890}', // sparkles
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14 + (animValue * 1.5),
                  color: primary,
                  shadows: [
                    Shadow(
                      color: primary.withValues(alpha: 0.8),
                      blurRadius: 6 * animValue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

/// Futuristic Thinking Animation Card
class FuturisticAiThinkingCard extends StatefulWidget {
  final ThemeData theme;

  const FuturisticAiThinkingCard({super.key, required this.theme});

  @override
  State<FuturisticAiThinkingCard> createState() =>
      _FuturisticAiThinkingCardState();
}

class _FuturisticAiThinkingCardState extends State<FuturisticAiThinkingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s12.symmetric.vertical,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1E1B) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header status badge
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.8),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              Spacing.s8.w,
              Text(
                "MENTORA AI NEURAL PROCESSING",
                style: r10.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: primary,
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          // Animated futuristic wave bars and text
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (i) {
                      final phase = (i * 0.25);
                      final t = (_waveController.value + phase) % 1.0;
                      final height = 6.0 + 14.0 * math.sin(t * math.pi);

                      return Container(
                        margin: EdgeInsets.only(right: 4.w),
                        width: 3.5.w,
                        height: height.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              primary,
                              lightGreen,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
              Spacing.s12.w,
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  final opacity =
                      0.5 + 0.5 * math.sin(_waveController.value * 2 * math.pi);
                  return Opacity(
                    opacity: opacity.clamp(0.4, 1.0),
                    child: Text(
                      "Crafting mindful insights...",
                      style: r14.copyWith(
                        color: widget.theme.textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Futuristic AI Message Content Card
class FuturisticAiMessageCard extends StatelessWidget {
  final MessageModel message;
  final int index;
  final ChatAIController controller;
  final ThemeData theme;

  const FuturisticAiMessageCard({
    super.key,
    required this.message,
    required this.index,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isSpeaking =
          controller.currentlySpeakingMessageId.value == message.id;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: isSpeaking
                ? primary.withValues(alpha: 0.7)
                : (isDark
                    ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
                    : primary.withValues(alpha: 0.18)),
            width: isSpeaking ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSpeaking
                  ? primary.withValues(alpha: 0.18)
                  : const Color.fromRGBO(0, 0, 0, 0.03),
              offset: const Offset(0, 2),
              blurRadius: isSpeaking ? 14 : 6,
              spreadRadius: isSpeaking ? 1 : 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top futuristic header strip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s12.symmetric.horizontal,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : primary.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(19),
                  topLeft: Radius.circular(3),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : primary.withValues(alpha: 0.08),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isSpeaking ? successColor : primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacing.s4.w,
                      Text(
                        "✦ MENTORA AI",
                        style: r10.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  if (isSpeaking)
                    const SoundWaveEqualizer()
                  else
                    Text(
                      _formatTime(message.timestamp),
                      style: r10.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            // Message Body (Markdown)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s12.symmetric.horizontal,
                vertical: Spacing.s8.symmetric.vertical,
              ),
              child: MarkdownBody(
                data: message.message,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: r16.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                  ),
                  pPadding: EdgeInsets.zero,
                  listBullet: r16.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                  strong: r16.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                  ),
                  code: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 13.sp,
                    color: isDark ? primary : const Color(0xFF2E6334),
                    backgroundColor: isDark
                        ? const Color(0xFF141713)
                        : primary.withValues(alpha: 0.12),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF141713)
                        : primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Action Buttons Row (Speak, Copy)
            Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.s8.symmetric.horizontal,
                0,
                Spacing.s8.symmetric.horizontal,
                Spacing.s4.symmetric.vertical,
              ),
              child: _buildFuturisticAiActionRow(context),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFuturisticAiActionRow(BuildContext context) {
    return Obx(() {
      final isSpeaking =
          controller.currentlySpeakingMessageId.value == message.id;
      final isCopied = controller.copiedMessageId.value == message.id;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionPill(
            iconUnicode: isSpeaking ? '\u{f04d}' : '\u{f028}', // stop or speaker
            label: isSpeaking ? 'Stop' : 'Speak',
            tooltip: isSpeaking ? 'Stop speaking' : 'Read aloud',
            isActive: isSpeaking,
            onTap: () => controller.toggleSpeak(message),
          ),
          Spacing.s8.w,
          _buildActionPill(
            iconUnicode: isCopied ? '\u{f00c}' : '\u{f0c5}', // check or copy
            label: isCopied ? 'Copied' : 'Copy',
            tooltip: isCopied ? 'Copied to clipboard' : 'Copy response',
            isActive: isCopied,
            onTap: () => controller.copyMessage(message),
          ),
        ],
      );
    });
  }

  Widget _buildActionPill({
    required String iconUnicode,
    required String label,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final defaultColor = theme.textTheme.bodySmall!.color!.withValues(alpha: 0.7);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 3.h,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? primary.withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  iconUnicode,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 11,
                    color: isActive ? primary : defaultColor,
                  ),
                ),
                Spacing.s4.w,
                Text(
                  label,
                  style: r10.copyWith(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? primary : defaultColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

/// Mini Animated Soundwave Equalizer for speaking state
class SoundWaveEqualizer extends StatefulWidget {
  const SoundWaveEqualizer({super.key});

  @override
  State<SoundWaveEqualizer> createState() => _SoundWaveEqualizerState();
}

class _SoundWaveEqualizerState extends State<SoundWaveEqualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _equalizerController;

  @override
  void initState() {
    super.initState();
    _equalizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _equalizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _equalizerController,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SPEAKING",
              style: r10.copyWith(
                fontWeight: FontWeight.w700,
                color: primary,
                letterSpacing: 0.6,
              ),
            ),
            Spacing.s4.w,
            ...List.generate(3, (i) {
              final phase = i * 0.33;
              final t = (_equalizerController.value + phase) % 1.0;
              final height = 4.0 + 8.0 * math.sin(t * math.pi);

              return Container(
                margin: EdgeInsets.only(left: 2.w),
                width: 2.w,
                height: height.h,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
