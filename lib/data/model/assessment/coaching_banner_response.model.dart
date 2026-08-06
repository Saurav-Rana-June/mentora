class CoachingBannerResponseModel {
  final String title;
  final String description;
  final String icon;

  CoachingBannerResponseModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory CoachingBannerResponseModel.fromJson(Map<String, dynamic> json) {
    return CoachingBannerResponseModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}
