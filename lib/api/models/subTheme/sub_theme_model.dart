import 'package:json_annotation/json_annotation.dart';

part 'sub_theme_model.g.dart';

@JsonSerializable()
class SubThemeApiModel {
  int? id;
  String? description;
  String? icon;
  String? created_at;
  String? updated_at;
  int? thematic_area_id;

  SubThemeApiModel(this.id, this.description, this.icon, this.created_at,
      this.updated_at, this.thematic_area_id);

  factory SubThemeApiModel.fromJson(Map<String, dynamic> json) => _$SubThemeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubThemeApiModelToJson(this);
}