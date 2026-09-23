class Speciality {
  final int? id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const Speciality({
    this.id,
    required this.name,
    this.description,
    this.icon = 'spa',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'] as int?,
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      icon: json['icon'] as String? ?? 'spa',
      isActive: (json['isActive'] as bool?) ?? (json['is_active'] as bool?) ?? true,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
      updatedAt: json['updatedAt'] as String? ?? json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      'isActive': isActive,
    };
  }
}
