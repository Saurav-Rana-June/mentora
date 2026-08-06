import 'package:flutter/material.dart';

class GrowthAreasResponseModel {
  final bool hasSufficientData;
  final List<GrowthAreaModel>? areas;
  final String? placeholderMessage;

  GrowthAreasResponseModel({
    required this.hasSufficientData,
    this.areas,
    this.placeholderMessage,
  });

  factory GrowthAreasResponseModel.fromJson(Map<String, dynamic> json) {
    return GrowthAreasResponseModel(
      hasSufficientData: json['hasSufficientData'] as bool? ?? false,
      areas: (json['areas'] as List<dynamic>?)
          ?.map((e) => GrowthAreaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeholderMessage: json['placeholderMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasSufficientData': hasSufficientData,
      'areas': areas?.map((e) => e.toJson()).toList(),
      'placeholderMessage': placeholderMessage,
    };
  }
}

class GrowthAreaModel {
  final String title;
  final double progress;
  final String tip;
  final String icon;
  final IconData? localIcon;

  GrowthAreaModel({
    required this.title,
    required this.progress,
    required this.tip,
    required this.icon,
    this.localIcon,
  });

  factory GrowthAreaModel.fromJson(Map<String, dynamic> json) {
    return GrowthAreaModel(
      title: json['title'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      tip: json['tip'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'progress': progress, 'tip': tip, 'icon': icon};
  }

  IconData get iconData {
    if (localIcon != null) return localIcon!;
    switch (icon.toLowerCase()) {
      case 'favorite_outline':
      case 'favorite':
        return Icons.favorite_outline;
      case 'psychology_outlined':
      case 'psychology':
        return Icons.psychology_outlined;
      case 'people_outline':
      case 'people':
        return Icons.people_outline;
      case 'menu_book_outlined':
      case 'menu_book':
        return Icons.menu_book_outlined;
      case 'self_improvement_outlined':
      case 'self_improvement':
        return Icons.self_improvement_outlined;
      case 'air_outlined':
      case 'air':
        return Icons.air_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
