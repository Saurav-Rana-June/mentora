import 'package:json_annotation/json_annotation.dart';
import 'expert.model.dart';

part 'paginated_experts.model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedExpertsModel {
  final List<Expert>? items;
  final int? page;
  final int? size;
  final int? totalItems;
  final int? totalPages;

  PaginatedExpertsModel({
    this.items,
    this.page,
    this.size,
    this.totalItems,
    this.totalPages,
  });

  factory PaginatedExpertsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedExpertsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedExpertsModelToJson(this);
}
