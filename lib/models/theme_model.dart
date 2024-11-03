import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/theme/theme_model.dart';

part 'theme_model.g.dart';

@JsonSerializable()
class ThemeModel {
  int id;
  String description;
  String icon;
  int displayIndex;

  ThemeModel({required this.id,
    required this.description,
    required this.icon,
    required this.displayIndex});

  factory ThemeModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);

  factory ThemeModel.fromApiModel(ThemeApiModel model) {
    return ThemeModel(id: model.id ?? -1,
        description:  model.description ?? '',
        icon:  model.icon ?? '',
        displayIndex:  model.display_index ?? -1);
  }
}
