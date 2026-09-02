import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/fields/custom_textfield.widget.dart';
import '../../../widgets/others/custom.primary.card.dart';
import '../controllers/chat_a_i.controller.dart';
import '../models/chat_session.model.dart';

class ChatAIDrawer extends StatelessWidget {
  final ChatAIController controller;

  const ChatAIDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = TextEditingController();

    // Sample dummy chats if user has no sessions or to populate dummy data
    final dummyChats = [
      ChatSessionModel(
        id: 'dummy_1',
        title: 'Overcoming Morning Anxiety',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
        messages: [
          MessageModel(
            message: 'I feel really anxious when I wake up in the morning.',
            isMe: true,
          ),
          MessageModel(
            message:
                'Morning anxiety is very common due to morning cortisol spikes. Let’s try 3 grounding steps together.',
            isMe: false,
          ),
        ],
      ),
      ChatSessionModel(
        id: 'dummy_2',
        title: 'Mindfulness & Sleep Routine',
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        messages: [
          MessageModel(
            message: 'Can you guide me on a bedtime wind-down routine?',
            isMe: true,
          ),
          MessageModel(
            message:
                'Here is a peaceful 15-minute routine with dim lighting, 4-7-8 breathing, and gratitude reflection.',
            isMe: false,
          ),
        ],
      ),
      ChatSessionModel(
        id: 'dummy_3',
        title: 'Deep Breathing Session',
        updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        messages: [
          MessageModel(
            message: 'Could we do a quick 2-minute box breathing session?',
            isMe: true,
          ),
          MessageModel(
            message:
                'Inhale for 4 seconds... Hold for 4... Exhale for 4... Hold for 4.',
            isMe: false,
          ),
        ],
      ),
      ChatSessionModel(
        id: 'dummy_4',
        title: 'Work Stress & Burnout Relief',
        updatedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        messages: [
          MessageModel(
            message:
                'I have a lot of deadlines and feeling completely overwhelmed.',
            isMe: true,
          ),
          MessageModel(
            message:
                'Take a deep breath. Let’s break down your tasks into micro-steps to reduce cognitive overload.',
            isMe: false,
          ),
        ],
      ),
      ChatSessionModel(
        id: 'dummy_5',
        title: 'Daily Mindfulness Quote',
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        messages: [
          MessageModel(
            message: 'Give me a mindfulness quote for reflection.',
            isMe: true,
          ),
          MessageModel(
            message:
                '"You cannot control the waves, but you can learn to surf." – Jon Kabat-Zinn',
            isMe: false,
          ),
        ],
      ),
    ];

    return Drawer(
      width: 0.84.sw,
      backgroundColor: theme.primaryColorLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s16.symmetric.horizontal,
            vertical: Spacing.s12.symmetric.horizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34.h,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '\u{f1da}', // history icon
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 15,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      Spacing.s12.w,
                      Text(
                        "Chat History",
                        style: h3.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          MyIcons.xmark,
                          style: TextStyle(
                            fontFamily: 'FontAwesomeLight',
                            fontSize: 18,
                            color: theme.textTheme.bodySmall!.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s16.h,
              // "+ New Chat" Button
              CustomPrimaryCard(
                borderRadius: 14,
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s12.symmetric.horizontal,
                  vertical: Spacing.s8.symmetric.horizontal,
                ),
                color: primary.withValues(alpha: 0.15),
                border: Border.all(
                  color: primary.withValues(alpha: 0.4),
                  width: 1,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.createNewChat();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\u{f067}', // plus
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 13,
                        color: primary,
                      ),
                    ),
                    Spacing.s8.w,
                    Text(
                      "Start New Chat",
                      style: r14.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s12.h,
              // Search input
              Container(
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        theme.dividerTheme.color ??
                        primary.withValues(alpha: 0.08),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: Spacing.s12.symmetric.horizontal,
                      ),
                      child: Text(
                        MyIcons.magnifyingGlass,
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 13,
                          color: theme.textTheme.bodySmall!.color!.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "Search chats...",
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        borderWidth: 0,
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Spacing.s8.symmetric.horizontal,
                          vertical: Spacing.s8.symmetric.vertical,
                        ),
                        onChanged: (val) {
                          controller.historySearchQuery.value = val;
                        },
                      ),
                    ),
                    Obx(() {
                      if (controller.historySearchQuery.value.isNotEmpty) {
                        return InkWell(
                          onTap: () {
                            searchController.clear();
                            controller.historySearchQuery.value = "";
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.s12.symmetric.horizontal,
                            ),
                            child: Text(
                              MyIcons.xmark,
                              style: TextStyle(
                                fontFamily: 'FontAwesomeLight',
                                fontSize: 13,
                                color: theme.textTheme.bodySmall!.color,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              Spacing.s16.h,
              // Chat List (combines active sessions and dummy history)
              Expanded(
                child: Obx(() {
                  final query = controller.historySearchQuery.value
                      .trim()
                      .toLowerCase();

                  // Merge user sessions with dummy chats if empty, or display user sessions + dummy fallback
                  final allChats = controller.sessions.isNotEmpty
                      ? controller.sessions.toList()
                      : dummyChats;

                  final filtered = allChats.where((s) {
                    if (query.isEmpty) return true;
                    final matchTitle = s.title.toLowerCase().contains(query);
                    final matchMsg = s.messages.any(
                      (m) => m.message.toLowerCase().contains(query),
                    );
                    return matchTitle || matchMsg;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(
                          Spacing.s16.symmetric.horizontal,
                        ),
                        child: Text(
                          "No conversations found for '$query'",
                          style: r12.copyWith(
                            color: theme.textTheme.bodySmall!.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => Spacing.s8.h,
                    itemBuilder: (context, index) {
                      final chat = filtered[index];
                      final isCurrent =
                          controller.currentSession.value?.id == chat.id;

                      return _buildDrawerChatCard(context, chat, isCurrent);
                    },
                  );
                }),
              ),
              Spacing.s12.h,
              // Footer
              Obx(() {
                if (controller.sessions.isEmpty) {
                  return const SizedBox.shrink();
                }
                return InkWell(
                  onTap: () => _confirmClearAll(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          MyIcons.trash,
                          style: TextStyle(
                            fontFamily: 'FontAwesomeLight',
                            fontSize: 14,
                            color: dangerColor,
                          ),
                        ),
                        Spacing.s8.w,
                        Text(
                          "Clear History",
                          style: r12.copyWith(
                            color: dangerColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerChatCard(
    BuildContext context,
    ChatSessionModel chat,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      borderRadius: 14,
      border: Border.all(
        color: isCurrent
            ? primary.withValues(alpha: 0.6)
            : theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
        width: isCurrent ? 1.4 : 0.8,
      ),
      padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
      onTap: () {
        Navigator.of(context).pop();
        controller.selectSession(chat);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '\u{f0e5}', // chat comment icon
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 12,
                  color: isCurrent
                      ? primary
                      : theme.textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s8.w,
              Expanded(
                child: Text(
                  chat.title,
                  style: r14.copyWith(
                    color: isCurrent
                        ? primary
                        : theme.textTheme.bodyLarge!.color,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.s8.w,
              Text(
                chat.formattedDate,
                style: r10.copyWith(
                  color: theme.textTheme.bodySmall!.color!.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ],
          ),
          Spacing.s4.h,
          Text(
            chat.lastMessageSnippet,
            style: r12.copyWith(
              color: theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacing.s4.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${chat.messages.length} ${chat.messages.length == 1 ? 'msg' : 'msgs'}",
                  style: r10.copyWith(
                    color: theme.textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Active",
                    style: r10.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: slate[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Clear All History",
          style: h3.copyWith(color: dangerColor, fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Are you sure you want to delete all chat history?",
          style: r14.copyWith(color: white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: r14.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.back();
              Navigator.of(context).pop();
              controller.clearAllHistory();
            },
            child: Text("Clear All", style: r14.copyWith(color: white)),
          ),
        ],
      ),
    );
  }
}
