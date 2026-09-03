import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'growth_areas_response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class GrowthAreasResponseModel {
  bool? hasSufficientData;
  List<GrowthAreaModel>? areas;
  String? placeholderMessage;

  GrowthAreasResponseModel({
    this.hasSufficientData,
    this.areas,
    this.placeholderMessage,
  });

  factory GrowthAreasResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GrowthAreasResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthAreasResponseModelToJson(this);
}

@JsonSerializable()
class GrowthAreaModel {
  String? title;
  double? progress;
  String? tip;
  String? icon;

  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData? localIcon;

  GrowthAreaModel({
    this.title,
    this.progress,
    this.tip,
    this.icon,
    this.localIcon,
  });

  factory GrowthAreaModel.fromJson(Map<String, dynamic> json) =>
      _$GrowthAreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthAreaModelToJson(this);

  IconData get iconData {
    if (localIcon != null) return localIcon!;
    switch (icon?.toLowerCase()) {
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
