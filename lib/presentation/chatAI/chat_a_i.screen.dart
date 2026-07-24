import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/bottomsheets/clear_chat.bottomsheet.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/fields/custom_textfield.widget.dart';
import 'controllers/chat_a_i.controller.dart';

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
          if (!showAppBar) {
            return RepaintBoundary(
              key: controller.exportKey,
              child: Container(
                color: Theme.of(context).primaryColorLight,
                child: body,
              ),
            );
          }
          return RepaintBoundary(
            key: controller.exportKey,
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColorLight,
              appBar: buildAppbar(context),
              body: body,
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(() {
        final isEmpty = controller.messages.isEmpty;
        return Column(
          children: [
            Expanded(
              child: isEmpty ? buildLandingContent(context) : buildChatArea(),
            ),
            if (!isEmpty) buildMessageBoxArea(context),
          ],
        );
      }),
    );
  }

  Widget buildLandingContent(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _FuturisticBackground()),
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s16.symmetric.horizontal,
              vertical: Spacing.s20.symmetric.horizontal,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildGreeting(context),
                Spacing.s32.h,
                buildCenterMessageBoxArea(context),
                Spacing.s24.h,
                buildCompactSuggestions(context),
              ],
            ),
          ),
        ),
      ],
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
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
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
      ),
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
              horizontal: Spacing.s16.symmetric.horizontal,
              vertical: Spacing.s12.symmetric.vertical,
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
      child: Row(
        children: [
          buildCompactSuggestionChip(
            context,
            title: "Feeling Anxious",
            iconUnicode: '\u{f004}', // heart
            query:
                "I'm feeling really anxious right now. Can you help me calm down?",
          ),
          Spacing.s8.w,
          buildCompactSuggestionChip(
            context,
            title: "Breathing Exercise",
            iconUnicode: '\u{f72e}', // wind
            query: "Could we do a quick breathing exercise together to relax?",
          ),
          Spacing.s8.w,
          buildCompactSuggestionChip(
            context,
            title: "Stress Relief",
            iconUnicode: '\u{f471}', // brain
            query:
                "I have a lot of stress lately and feel overwhelmed. How should I handle it?",
          ),
          Spacing.s8.w,
          buildCompactSuggestionChip(
            context,
            title: "Mindfulness Quote",
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
    required String iconUnicode,
    required String query,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => controller.sendMessage(query),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s12.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.vertical,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  iconUnicode,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 10,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Spacing.s8.w,
              Text(
                title,
                style: r12.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatArea() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.messages.length,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s12.symmetric.vertical,
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
          child: Container(
            margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s12.symmetric.horizontal,
              vertical: Spacing.s8.symmetric.horizontal,
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
              style: r16.copyWith(color: white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: Spacing.s8.symmetric.horizontal),
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\u{f890}', // sparkles icon
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 0.7.sw),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s12.symmetric.horizontal,
                      vertical: Spacing.s8.symmetric.horizontal,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.03),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      message.message,
                      style: r16.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Container buildMessageBoxArea(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.vertical,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        border: Border(
          top: BorderSide(
            color: theme.dividerTheme.color ?? theme.colorScheme.outlineVariant,
            width: 0.8,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.1),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              hintText: "Write a message...",
              controller: controller.messageController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              maxLines: 2,
              minLines: 1,
              borderWidth: 0,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.s16.symmetric.horizontal,
                vertical: Spacing.s12.symmetric.vertical,
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
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          '\u{002b}',
                          style: TextStyle(
                            fontFamily: 'FontAwesomeRegular',
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: theme.textTheme.bodyMedium!.color!
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    final text = controller.currentInputText.value;
                    final isNotEmpty = text.trim().isNotEmpty;
                    return Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isNotEmpty ? 8 : 20,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          isNotEmpty ? 8 : 20,
                        ),
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
                            borderRadius: BorderRadius.circular(
                              isNotEmpty ? 8 : 20,
                            ),
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
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: Obx(
        () => controller.isSearching.value
            ? buildSearchAppbar(context)
            : buildNormalAppbar(context),
      ),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
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
              onTap: () {},
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
                    '\u{f0c9}',
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 16,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        buildOptionsDropdownButtton(context),
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
        child: const CircleAvatar(
          radius: 17,
          backgroundImage: NetworkImage(
            "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
          ),
        ),
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
