import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../controllers/global.controller.dart';
import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/others/custom.avatar.dart';
import '../controllers/chat_a_i.controller.dart';
import '../models/chat_session.model.dart';

class ChatAIDrawer extends StatelessWidget {
  final ChatAIController controller;

  const ChatAIDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // High quality dummy conversations to showcase when list is fresh or dummy preview
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
                'Morning anxiety is very common due to cortisol spikes. Let’s try 3 grounding steps together.',
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
      width: 0.86.sw,
      backgroundColor: theme.primaryColorLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColorLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            bottomLeft: Radius.circular(28),
          ),
          border: Border(
            left: BorderSide(color: primary.withValues(alpha: 0.12), width: 1),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Header Section
              _buildHeader(context),
              Spacing.s12.h,

              // Action CTA: New Chat Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s16.symmetric.horizontal,
                ),
                child: _buildNewChatButton(context),
              ),
              Spacing.s12.h,

              // Chat List Grouped by Date
              Expanded(
                child: Obx(() {
                  final query = controller.historySearchQuery.value
                      .trim()
                      .toLowerCase();

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
                    return _buildEmptySearchState(context, query);
                  }

                  final groupedChats = _groupChatsByDate(filtered);

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s16.symmetric.horizontal,
                      vertical: Spacing.s4.symmetric.vertical,
                    ),
                    itemCount: groupedChats.length,
                    itemBuilder: (context, index) {
                      final groupTitle = groupedChats.keys.elementAt(index);
                      final chatsInGroup = groupedChats[groupTitle]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            groupTitle,
                            chatsInGroup.length,
                          ),
                          Spacing.s8.h,
                          ...chatsInGroup.map((chat) {
                            final isCurrent =
                                controller.currentSession.value?.id == chat.id;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Spacing.s8.h.height!,
                              ),
                              child: _buildChatCard(context, chat, isCurrent),
                            );
                          }),
                          Spacing.s8.h,
                        ],
                      );
                    },
                  );
                }),
              ),

              // Bottom User Profile & Clear History Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.s16.symmetric.horizontal,
        Spacing.s12.symmetric.horizontal,
        Spacing.s16.symmetric.horizontal,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withValues(alpha: 0.25),
                      primary.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '\u{f890}', // sparkles / AI icon
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 15,
                      color: primary,
                    ),
                  ),
                ),
              ),
              Spacing.s12.w,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chat History",
                    style: h3.copyWith(
                      color: theme.textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  Obx(() {
                    final count = controller.sessions.length;
                    return Text(
                      count > 0
                          ? "$count saved conversations"
                          : "Recent conversations",
                      style: r10.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withValues(
                          alpha: 0.6,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 32.h,
                width: 32.h,
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
                    MyIcons.xmark,
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 14,
                      color: theme.textTheme.bodySmall!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChatButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pop();
          controller.createNewChat();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s16.symmetric.horizontal,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withValues(alpha: 0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '\u{f067}', // plus
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 11,
                    color: white,
                  ),
                ),
              ),
              Spacing.s12.w,
              Text(
                "New Conversation",
                style: r14.copyWith(
                  color: white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: EdgeInsets.only(
        top: Spacing.s8.h.height!,
        left: Spacing.s4.symmetric.horizontal,
      ),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: r10.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          Spacing.s8.w,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: r10.copyWith(
                color: primary,
                fontWeight: FontWeight.w600,
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(
    BuildContext context,
    ChatSessionModel chat,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    final topicIcon = _getTopicIcon(chat.title);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pop();
          controller.selectSession(chat);
        },
        child: Container(
          padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
          decoration: BoxDecoration(
            color: isCurrent
                ? primary.withValues(alpha: 0.08)
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent
                  ? primary.withValues(alpha: 0.55)
                  : theme.dividerTheme.color ?? primary.withValues(alpha: 0.06),
              width: isCurrent ? 1.4 : 0.8,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Topic Icon + Title + Relative Date
              Row(
                children: [
                  Container(
                    width: 28.h,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? primary.withValues(alpha: 0.2)
                          : primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        topicIcon,
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 12,
                          color: primary,
                        ),
                      ),
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
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacing.s8.w,
                  Text(
                    _formatRelativeTime(chat.updatedAt),
                    style: r10.copyWith(
                      color: theme.textTheme.bodySmall!.color!.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacing.s4.h,

              // Middle: Snippet Preview
              Padding(
                padding: EdgeInsets.only(left: 36.h),
                child: Text(
                  chat.lastMessageSnippet,
                  style: r12.copyWith(
                    color: theme.textTheme.bodyMedium!.color!.withValues(
                      alpha: 0.65,
                    ),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.s8.h,

              // Bottom Row: Message Count Badge + Active Chip + Delete Button
              Padding(
                padding: EdgeInsets.only(left: 36.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColorLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  theme.dividerTheme.color ??
                                  primary.withValues(alpha: 0.05),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            "${chat.messages.length} ${chat.messages.length == 1 ? 'msg' : 'msgs'}",
                            style: r10.copyWith(
                              color: theme.textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          Spacing.s4.w,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Spacing.s4.w,
                                Text(
                                  "Active",
                                  style: r10.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _confirmDeleteChat(context, chat),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          MyIcons.trash,
                          style: TextStyle(
                            fontFamily: 'FontAwesomeLight',
                            fontSize: 13,
                            color: dangerColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final globalController = Get.find<GlobalController>();
    final profile = globalController.userProfile.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
        vertical: Spacing.s12.symmetric.horizontal,
      ),
      decoration: BoxDecoration(
        color:
            theme.cardTheme.color?.withValues(alpha: 0.65) ??
            theme.primaryColorLight,
        border: Border(
          top: BorderSide(
            color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomAvatar(
                radius: 17,
                imageUrl: profile?.profilePictureUrl,
                name: profile?.name,
              ),
              Spacing.s12.w,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile?.name ?? "Mentora User",
                    style: r14.copyWith(
                      color: theme.textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Private Safe Space",
                    style: r10.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(() {
            if (controller.sessions.isEmpty) {
              return const SizedBox.shrink();
            }
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _confirmClearAll(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: dangerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: dangerColor.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MyIcons.trash,
                      style: TextStyle(
                        fontFamily: 'FontAwesomeLight',
                        fontSize: 12,
                        color: dangerColor,
                      ),
                    ),
                    Spacing.s4.w,
                    Text(
                      "Clear All",
                      style: r10.copyWith(
                        color: dangerColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState(BuildContext context, String query) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.s24.symmetric.horizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  MyIcons.magnifyingGlass,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 20,
                    color: theme.textTheme.bodySmall!.color!.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            Spacing.s12.h,
            Text(
              "No chats found",
              style: r14.copyWith(
                color: theme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.s4.h,
            Text(
              "No conversation matched '$query'.",
              style: r12.copyWith(
                color: theme.textTheme.bodySmall!.color!.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<ChatSessionModel>> _groupChatsByDate(
    List<ChatSessionModel> chats,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    final Map<String, List<ChatSessionModel>> groups = {};

    for (final chat in chats) {
      final chatDate = DateTime(
        chat.updatedAt.year,
        chat.updatedAt.month,
        chat.updatedAt.day,
      );
      String groupKey;

      if (chatDate == today) {
        groupKey = "Today";
      } else if (chatDate == yesterday) {
        groupKey = "Yesterday";
      } else if (chatDate.isAfter(sevenDaysAgo)) {
        groupKey = "Previous 7 Days";
      } else {
        groupKey = "Older";
      }

      groups.putIfAbsent(groupKey, () => []).add(chat);
    }

    return groups;
  }

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays == 1) return "Yesterday";
    if (diff.inDays < 7) return "${diff.inDays}d ago";
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[dt.month - 1]} ${dt.day}";
  }

  String _getTopicIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains("anxiety") || lower.contains("calm")) {
      return '\u{f004}'; // heart
    }
    if (lower.contains("breath") || lower.contains("wind")) {
      return '\u{f72e}'; // wind
    }
    if (lower.contains("stress") ||
        lower.contains("burnout") ||
        lower.contains("overwhelm")) {
      return '\u{f471}'; // brain
    }
    if (lower.contains("quote") || lower.contains("mindful")) {
      return '\u{f890}'; // sparkles
    }
    return '\u{f0e5}'; // comments
  }

  void _confirmDeleteChat(BuildContext context, ChatSessionModel chat) {
    Get.dialog(
      AlertDialog(
        backgroundColor: slate[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Delete Conversation",
          style: h3.copyWith(color: dangerColor, fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Are you sure you want to delete '${chat.title}'?",
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
              controller.deleteSession(chat.id);
            },
            child: Text("Delete", style: r14.copyWith(color: white)),
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
          "Are you sure you want to delete all saved conversations? This cannot be undone.",
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
