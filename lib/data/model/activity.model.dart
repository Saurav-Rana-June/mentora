class ActivityModel {
  final int id;
  final String title;
  final String caption;
  final String icon;
  final String duration;
  final String category;
  final List<String> tags;
  final bool isSafetyPriority;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.caption,
    required this.icon,
    required this.duration,
    required this.category,
    this.tags = const [],
    this.isSafetyPriority = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      icon: json['icon'] as String? ?? 'box',
      duration: json['duration'] as String? ?? '5 min',
      category: json['category'] as String? ?? 'breathing',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isSafetyPriority: json['isSafetyPriority'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'caption': caption,
      'icon': icon,
      'duration': duration,
      'category': category,
      'tags': tags,
      'isSafetyPriority': isSafetyPriority,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
