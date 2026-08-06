class PlanModel {
  final int id;
  final int activityId;
  final String title;
  final String caption;
  final String icon;
  final String duration;
  final String category;
  final int sortOrder;
  final bool isComplete;

  PlanModel({
    required this.id,
    required this.activityId,
    required this.title,
    required this.caption,
    required this.icon,
    required this.duration,
    required this.category,
    required this.sortOrder,
    required this.isComplete,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as int? ?? 0,
      activityId: json['activityId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      category: json['category'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      isComplete: json['isComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'title': title,
      'caption': caption,
      'icon': icon,
      'duration': duration,
      'category': category,
      'sortOrder': sortOrder,
      'isComplete': isComplete,
    };
  }

  // Getters for UI component consumption
  String get uiTitle => category.toUpperCase();
  String get label => title;
  String get uiCaption => '$duration • $caption';
  
  String get uiIcon {
    switch (icon.toLowerCase()) {
      case 'box':
      case 'box-breathing':
      case 'breathing':
        return '\u{f800}';
      case 'lotus':
      case 'meditation':
      case 'spa':
        return '\u{f800}';
      case 'moon':
      case 'sleep':
        return '\u{f186}';
      case 'heart':
      case 'love':
      case 'gratitude':
        return '\u{f004}';
      case 'journaling':
      case 'book':
        return '\u{f02d}';
      case 'movement':
      case 'running':
      case 'walking':
        return '\u{f70c}';
      default:
        return '\u{f800}';
    }
  }
}
