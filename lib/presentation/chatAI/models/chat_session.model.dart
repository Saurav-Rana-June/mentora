class MessageModel {
  final String id;
  final String message;
  final bool isMe;
  final DateTime timestamp;

  MessageModel({
    String? id,
    required this.message,
    required this.isMe,
    DateTime? timestamp,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'isMe': isMe,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String?,
        message: json['message'] as String? ?? '',
        isMe: json['isMe'] as bool? ?? false,
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}

class ChatSessionModel {
  final String id;
  String title;
  final DateTime createdAt;
  DateTime updatedAt;
  List<MessageModel> messages;

  ChatSessionModel({
    String? id,
    required this.title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MessageModel>? messages,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        messages = messages ?? [];

  String get lastMessageSnippet {
    if (messages.isEmpty) return 'No messages yet';
    final last = messages.last;
    final prefix = last.isMe ? 'You: ' : 'Mentora: ';
    final cleanMsg = last.message.replaceAll('\n', ' ').trim();
    if (cleanMsg.length > 50) {
      return '$prefix${cleanMsg.substring(0, 50)}...';
    }
    return '$prefix$cleanMsg';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare =
        DateTime(updatedAt.year, updatedAt.month, updatedAt.day);

    final hour = updatedAt.hour > 12
        ? updatedAt.hour - 12
        : (updatedAt.hour == 0 ? 12 : updatedAt.hour);
    final minute = updatedAt.minute.toString().padLeft(2, '0');
    final period = updatedAt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    if (dateToCompare == today) {
      return 'Today, $timeStr';
    } else if (dateToCompare == yesterday) {
      return 'Yesterday, $timeStr';
    } else {
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
        'Dec'
      ];
      return '${months[updatedAt.month - 1]} ${updatedAt.day}, $timeStr';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      ChatSessionModel(
        id: json['id'] as String?,
        title: json['title'] as String? ?? 'New Conversation',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
            : DateTime.now(),
        messages: (json['messages'] as List<dynamic>?)
                ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
