import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../infrastructure/theme/theme.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/widgets/others/custom.avatar.dart';
import '../../widgets/bottomsheets/clear_chat.bottomsheet.dart';
import '../../widgets/others/custom.screen.wrapper.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/fields/custom_textfield.widget.dart';
import '../../widgets/others/custom.primary.card.dart';
import 'controllers/chat_a_i.controller.dart';
import 'models/chat_session.model.dart';
import 'widgets/chat_a_i_drawer.dart';
import 'widgets/futuristic_ai_bubble.widget.dart';

class ChatAIScreen extends GetView<ChatAIController> {
  final bool showAppBar;
  final bool showBackButton;

  ChatAIScreen({super.key, this.showAppBar = true, this.showBackButton = true});

  @override
  final controller = Get.put(ChatAIController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final body = buildBody(context);
          return RepaintBoundary(
            key: controller.exportKey,
            child: CustomScreenWrapper(
              scaffoldKey: controller.scaffoldKey,
              endDrawer: ChatAIDrawer(controller: controller),
              safeAreaTop: false,
              body: body,
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return Obx(() {
      final isEmpty = controller.messages.isEmpty;
      return Stack(
        children: [
          const Positioned.fill(child: _FuturisticBackground()),
          Column(
            children: [
              Expanded(
                child: isEmpty
                    ? buildLandingContent(context, topPadding)
                    : buildChatArea(context, topPadding),
              ),
              if (!isEmpty) buildMessageBoxArea(context),
            ],
          ),
          if (showAppBar)
            Positioned(top: 0, left: 0, right: 0, child: buildAppbar(context)),
        ],
      );
    });
  }

  Widget buildLandingContent(BuildContext context, double topPadding) {
    return Center(
      child: SingleChildScrollView(
        controller: controller.landingScrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          0,
          Spacing.s32.symmetric.vertical,
          0,
          Spacing.s24.symmetric.horizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.s40.h,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s16.symmetric.horizontal,
              ),
              child: buildGreeting(context),
            ),
            Spacing.s32.h,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s16.symmetric.horizontal,
              ),
              child: buildCenterMessageBoxArea(context),
            ),
            Spacing.s24.h,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s16.symmetric.horizontal,
              ),
              child: Text(
                "Suggestions",
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacing.s12.h,
            buildCompactSuggestions(context),
          ],
        ),
      ),
    );
  }

  Widget buildRecentChatsList(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
      ),
      child: Obx(() {
        final recent = controller.sessions.take(4).toList();
        return Row(
          children: recent.map((session) {
            return Padding(
              padding: EdgeInsets.only(right: Spacing.s12.symmetric.horizontal),
              child: CustomPrimaryCard(
                borderRadius: 16,
                width: 190.w,
                height: 100.h,
                padding: EdgeInsets.all(Spacing.s8.symmetric.horizontal),
                border: Border.all(
                  color:
                      theme.dividerTheme.color ??
                      primary.withValues(alpha: 0.1),
                  width: 0.8,
                ),
                onTap: () => controller.selectSession(session),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\u{f0e5}', // chat icon
                          style: TextStyle(
                            fontFamily: 'FontAwesomeSolid',
                            fontSize: 12,
                            color: primary,
                          ),
                        ),
                        Spacing.s8.w,
                        Expanded(
                          child: Text(
                            session.title,
                            style: r14.copyWith(
                              color: theme.textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      session.lastMessageSnippet,
                      style: r10.copyWith(
                        color: theme.textTheme.bodyMedium!.color!.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      session.formattedDate,
                      style: r10.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget buildGreeting(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 60.h,
          height: 60.h,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
          ),
        ),
        Spacing.s16.h,
        Text(
          "Hello, I'm Mentora AI",
          style: h2.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Spacing.s8.h,
        Text(
          "Your safe space for mental well-being.",
          style: r18.copyWith(
            color: textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Spacing.s8.h,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s16.symmetric.horizontal,
          ),
          child: Text(
            "I'm here to listen, support, and guide you. Select a prompt below or type your own query to begin.",
            style: r14.copyWith(color: textTheme.bodyMedium!.color),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildCenterMessageBoxArea(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      borderRadius: 20,
      border: Border.all(
        color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.1),
        width: 0.8,
      ),
      boxShadow: [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: 16,
          spreadRadius: 2,
        ),
      ],
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            hintText: "Write a message...",
            controller: controller.messageController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.send,
            maxLines: 2,
            minLines: 2,
            borderWidth: 0,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
              vertical: Spacing.s8.symmetric.vertical,
            ),
            onFieldSubmitted: (value) {
              final text = value.trim();
              if (text.isNotEmpty) {
                controller.sendMessage(text);
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.s16.symmetric.horizontal,
              0,
              Spacing.s12.symmetric.horizontal,
              Spacing.s12.symmetric.vertical,
            ),
            child: Row(
              children: [
                // Material(
                //   color: Colors.transparent,
                //   shape: const CircleBorder(),
                //   child: InkWell(
                //     customBorder: const CircleBorder(),
                //     onTap: () {},
                //     child: Padding(
                //       padding: const EdgeInsets.all(4),
                //       child: Text(
                //         '\u{002b}',
                //         style: TextStyle(
                //           fontFamily: 'FontAwesomeRegular',
                //           fontSize: 20,
                //           fontWeight: FontWeight.w300,
                //           color: theme.textTheme.bodyMedium!.color!.withValues(
                //             alpha: 0.6,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const Spacer(),
                Obx(() {
                  final text = controller.currentInputText.value;
                  final isNotEmpty = text.trim().isNotEmpty;
                  return Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isNotEmpty ? 8 : 20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(isNotEmpty ? 8 : 20),
                      onTap: isNotEmpty
                          ? () => controller.sendMessage(text)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 36.h,
                        width: 36.h,
                        decoration: BoxDecoration(
                          color: isNotEmpty
                              ? primary
                              : primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '\u{f062}',
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 14,
                              color: isNotEmpty
                                  ? white
                                  : theme.textTheme.bodyMedium!.color!
                                        .withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompactSuggestions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
      ),
      child: Row(
        children: [
          buildCompactSuggestionChip(
            context,
            title: "Feeling Anxious",
            description: "Calm your mind and body with guided relaxation",
            iconUnicode: '\u{f004}', // heart
            query:
                "I'm feeling really anxious right now. Can you help me calm down?",
          ),
          Spacing.s16.w,
          buildCompactSuggestionChip(
            context,
            title: "Breathing Exercise",
            description: "Quick 2-minute deep breathing session",
            iconUnicode: '\u{f72e}', // wind
            query: "Could we do a quick breathing exercise together to relax?",
          ),
          Spacing.s16.w,
          buildCompactSuggestionChip(
            context,
            title: "Stress Relief",
            description: "Manage stress, anxiety, and pressure effectively",
            iconUnicode: '\u{f471}', // brain
            query:
                "I have a lot of stress lately and feel overwhelmed. How should I handle it?",
          ),
          Spacing.s16.w,
          buildCompactSuggestionChip(
            context,
            title: "Mindfulness Quote",
            description: "Get daily quote inspiration and reflection",
            iconUnicode: '\u{f890}', // sparkles
            query:
                "Give me a mindfulness quote and help me journal about my day.",
          ),
        ],
      ),
    );
  }

  Widget buildCompactSuggestionChip(
    BuildContext context, {
    required String title,
    required String description,
    required String iconUnicode,
    required String query,
  }) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      borderRadius: 20,
      width: 200.w,
      height: 120.h,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.vertical,
      ),
      border: Border.all(
        color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
        width: 0.8,
      ),
      onTap: () => controller.sendMessage(query),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              iconUnicode,
              style: TextStyle(
                fontFamily: 'FontAwesomeSolid',
                fontSize: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Spacing.s16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: r14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                // Spacing.s4.h,
                Text(
                  description,
                  style: r12.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.textTheme.bodySmall!.color!.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChatArea(BuildContext context, double topPadding) {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.messages.length,
      padding: EdgeInsets.fromLTRB(
        Spacing.s8.symmetric.horizontal,
        topPadding + 56.h + Spacing.s12.symmetric.vertical,
        Spacing.s8.symmetric.horizontal,
        Spacing.s12.symmetric.vertical,
      ),
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        return buildChatBubble(context, message, index);
      },
    );
  }

  Widget buildChatBubble(
    BuildContext context,
    MessageModel message,
    int index,
  ) {
    final theme = Theme.of(context);
    final isMe = message.isMe;

    if (isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 0.75.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4.h),
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s8.symmetric.horizontal,
                  vertical: Spacing.s4.symmetric.horizontal,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.message,
                  style: r16.copyWith(
                    color: white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              buildUserActionRow(context, message, index),
              Spacing.s8.h,
            ],
          ),
        ),
      );
    } else {
      return FuturisticAiBubble(
        message: message,
        index: index,
        controller: controller,
      );
    }
  }

  Widget buildUserActionRow(
    BuildContext context,
    MessageModel message,
    int index,
  ) {
    return Obx(() {
      final isSpeaking =
          controller.currentlySpeakingMessageId.value == message.id;
      final isCopied = controller.copiedMessageId.value == message.id;

      return Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildActionIconButton(
              iconUnicode: isSpeaking
                  ? '\u{f04d}'
                  : '\u{f028}', // stop or speaker
              tooltip: isSpeaking ? 'Stop speaking' : 'Speak',
              isActive: isSpeaking,
              onTap: () => controller.toggleSpeak(message),
            ),
            Spacing.s4.w,
            buildActionIconButton(
              iconUnicode: isCopied ? '\u{f00c}' : '\u{f0c5}', // check or copy
              tooltip: isCopied ? 'Copied' : 'Copy',
              isActive: isCopied,
              onTap: () => controller.copyMessage(message),
            ),
            Spacing.s4.w,
            buildActionIconButton(
              iconUnicode: '\u{f304}', // pen-to-square
              tooltip: 'Edit',
              isActive: false,
              onTap: () => controller.startEditMessage(message, index),
            ),
            Spacing.s4.w,
            buildActionIconButton(
              iconUnicode: '\u{f01e}', // rotate-right / retry
              tooltip: 'Retry',
              isActive: false,
              onTap: () => controller.retryMessage(message, index),
            ),
          ],
        ),
      );
    });
  }

  Widget buildActionIconButton({
    required String iconUnicode,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final defaultColor = theme.textTheme.bodySmall!.color!.withValues(
          alpha: 0.6,
        );

        return Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  iconUnicode,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 12,
                    color: isActive ? primary : defaultColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container buildMessageBoxArea(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        border: Border(
          top: BorderSide(
            color: theme.dividerTheme.color ?? theme.colorScheme.outlineVariant,
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final editingMsg = controller.editingMessage.value;
            if (editingMsg == null) return const SizedBox.shrink();
            final snippet = editingMsg.message.replaceAll('\n', ' ').trim();
            final displaySnippet = snippet.length > 40
                ? '${snippet.substring(0, 40)}...'
                : snippet;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s12.symmetric.horizontal,
                vertical: 6.h,
              ),
              color: primary.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Text(
                    '\u{f304}',
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 12,
                      color: primary,
                    ),
                  ),
                  Spacing.s8.w,
                  Expanded(
                    child: Text(
                      'Editing: "$displaySnippet"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: r12.copyWith(
                        color: theme.textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.cancelEdit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: theme.textTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s12.symmetric.horizontal,
              vertical: Spacing.s8.symmetric.vertical,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hintText: "Write a message...",
                    controller: controller.messageController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    maxLines: 3,
                    minLines: 1,
                    borderWidth: 0.8,
                    borderColor:
                        theme.dividerTheme.color ??
                        primary.withValues(alpha: 0.1),
                    fillColor: theme.cardTheme.color,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Spacing.s8.symmetric.horizontal,
                      vertical: Spacing.s8.symmetric.vertical,
                    ),
                    onFieldSubmitted: (value) {
                      final text = value.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(text);
                      }
                    },
                  ),
                ),
                Spacing.s16.w,
                Obx(() {
                  final text = controller.currentInputText.value;
                  final isNotEmpty = text.trim().isNotEmpty;
                  final isEditing = controller.editingMessage.value != null;
                  return Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      borderRadius: BorderRadius.circular(50),
                      onTap: isNotEmpty
                          ? () => controller.sendMessage(text)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: isNotEmpty
                              ? primary
                              : primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            isEditing ? '\u{f00c}' : '\u{f1d8}',
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 16,
                              color: isNotEmpty
                                  ? white
                                  : theme.textTheme.bodyMedium!.color!
                                        .withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppbar(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    return Obx(() {
      final isScrolled = controller.isScrolled.value;

      final barContent = Container(
        padding: EdgeInsets.fromLTRB(
          Spacing.s4.symmetric.horizontal,
          topPadding + Spacing.s4.symmetric.vertical,
          Spacing.s8.symmetric.horizontal,
          Spacing.s8.symmetric.vertical,
        ),
        color: isScrolled
            ? theme.primaryColorLight.withValues(alpha: 0.85)
            : Colors.transparent,
        child: controller.isSearching.value
            ? buildSearchAppbar(context)
            : buildNormalAppbar(context),
      );

      if (isScrolled) {
        return ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: barContent,
          ),
        );
      }

      return barContent;
    });
  }

  Row buildSearchAppbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  MyIcons.magnifyingGlass,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .5),
                  ),
                ),
                Expanded(
                  child: CustomTextFormField(
                    hintText: "Search here...",
                    fillColor: Colors.transparent,
                    controller: TextEditingController(),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                ),
                Text(
                  '\u{f078}', // chevron-down
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .75),
                  ),
                ),
                Spacing.s12.w,
                Text(
                  '\u{f077}', // chevron-up
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .75),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacing.s12.w,
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            customBorder: const CircleBorder(),
            splashColor: primary.withValues(alpha: 0.3),
            onTap: () {
              controller.isSearching.value = false;
            },
            child: Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  MyIcons.xmark,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildNormalAppbar(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          CustomBackButton(icon: MyIcons.chevronLeft)
        else
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => controller.openHistory(),
              child: Container(
                height: 38.h,
                width: 38.h,
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        theme.dividerTheme.color ??
                        primary.withValues(alpha: 0.08),
                    width: 0.8,
                  ),
                ),
                child: Center(
                  child: Text(
                    '\u{f1da}',
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 15,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // History Button
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                borderRadius: BorderRadius.circular(50),
                onTap: () => controller.openHistory(),
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          theme.dividerTheme.color ??
                          primary.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '\u{f1da}', // history icon
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 14,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacing.s8.w,
            // New Chat Button
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                borderRadius: BorderRadius.circular(50),
                onTap: () => controller.createNewChat(),
                child: Container(
                  height: 36.h,
                  width: 36.h,
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          theme.dividerTheme.color ??
                          primary.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '\u{f044}', // pen-to-square / compose / new chat
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 14,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacing.s8.w,
            buildOptionsDropdownButtton(context),
          ],
        ),
      ],
    );
  }

  Widget buildOptionsDropdownButtton(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      color: theme.cardColor,
      offset: const Offset(0, 48),
      onSelected: (value) {
        switch (value) {
          case 'new_chat':
            controller.createNewChat();
            break;
          case 'history':
            controller.openHistory();
            break;
          case 'search':
            controller.isSearching.value = true;
            break;
          case 'export':
            controller.exportChat(controller.exportKey);
            break;
          case 'clear':
            Get.bottomSheet(
              Theme(
                data: AppTheme.darkTheme,
                child: ClearChatBottomsheet(
                  onConfirm: () {
                    controller.clearChat();
                  },
                ),
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'new_chat',
          child: Row(
            children: [
              Text(
                '\u{f044}', // pen-to-square
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14,
                  color: primary,
                ),
              ),
              Spacing.s12.w,
              Text(
                'New Chat',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'history',
          child: Row(
            children: [
              Text(
                '\u{f1da}', // history
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Chat History',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'search',
          child: Row(
            children: [
              Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Search',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export',
          child: Row(
            children: [
              Text(
                '\u{f08b}',
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Export Chat',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              Text(
                MyIcons.trash,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: dangerColor,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Clear Chat',
                style: r16.copyWith(
                  color: dangerColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Obx(() {
          final globalController = Get.find<GlobalController>();
          final profile = globalController.userProfile.value;
          return CustomAvatar(
            radius: 17,
            imageUrl: profile?.profilePictureUrl,
            name: profile?.name,
          );
        }),
      ),
    );
  }
}

class _FuturisticBackground extends StatefulWidget {
  const _FuturisticBackground();

  @override
  State<_FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<_FuturisticBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AuroraBackgroundPainter(
              animationValue: _controller.value,
              primaryColor: theme.colorScheme.primary,
              cardColor: theme.cardColor,
            ),
          );
        },
      ),
    );
  }
}

class _AuroraBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color cardColor;

  _AuroraBackgroundPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.cardColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center1 = Offset(
      size.width * 0.2 + cos(animationValue * 2 * pi) * size.width * 0.1,
      size.height * 0.3 + sin(animationValue * 2 * pi) * size.height * 0.1,
    );
    final radius1 = size.width * 0.7;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.12),
          primaryColor.withValues(alpha: 0.03),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center1, radius: radius1))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center1, radius1, paint1);

    final center2 = Offset(
      size.width * 0.8 + cos(-animationValue * 2 * pi + pi) * size.width * 0.15,
      size.height * 0.6 +
          sin(-animationValue * 2 * pi + pi) * size.height * 0.12,
    );
    final radius2 = size.width * 0.8;

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.08),
          primaryColor.withValues(alpha: 0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center2, radius: radius2))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center2, radius2, paint2);

    final particlePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final seedPoints = [
      const Offset(0.15, 0.2),
      const Offset(0.85, 0.25),
      const Offset(0.5, 0.45),
      const Offset(0.3, 0.6),
      const Offset(0.7, 0.75),
      const Offset(0.2, 0.8),
    ];

    final positions = <Offset>[];
    for (int i = 0; i < seedPoints.length; i++) {
      final pt = seedPoints[i];
      final offset = Offset(
        size.width * pt.dx + cos(animationValue * 2 * pi + i) * 12,
        size.height * pt.dy + sin(animationValue * 3 * pi + i) * 12,
      );
      positions.add(offset);
      canvas.drawCircle(offset, 3, particlePaint);
    }

    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final dist = (positions[i] - positions[j]).distance;
        if (dist < size.width * 0.45) {
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.cardColor != cardColor;
  }
}
