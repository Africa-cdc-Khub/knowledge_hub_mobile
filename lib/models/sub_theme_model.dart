import 'package:khub_mobile/api/models/subTheme/sub_theme_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_theme_model.g.dart';

@JsonSerializable()
class SubThemeModel {
  int id;
  String description;
  String icon;
  String createdAt;
  String updatedAt;
  int thematicAreaId;

  SubThemeModel(
      {required this.id,
      required this.description,
      required this.icon,
      required this.createdAt,
      required this.updatedAt,
      required this.thematicAreaId});

  factory SubThemeModel.fromApiModel(SubThemeApiModel model) {
    return SubThemeModel(
        id: model.id ?? -1,
        description: model.description ?? '',
        icon: model.icon ?? '',
        createdAt: model.created_at ?? '',
        updatedAt: model.updated_at ?? '',
        thematicAreaId: model.thematic_area_id ?? -1);
  }

  factory SubThemeModel.fromJson(Map<String, dynamic> json) =>
      _$SubThemeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubThemeModelToJson(this);
}
