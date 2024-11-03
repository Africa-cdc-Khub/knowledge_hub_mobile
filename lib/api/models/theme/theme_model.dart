
import 'package:json_annotation/json_annotation.dart';

part 'theme_model.g.dart';

@JsonSerializable()
class ThemeApiModel {
  int? id;
  String? description;
  String? icon;
  // String? created_At;
  // String? updated_at;
  int? display_index;

  ThemeApiModel(this.id, this.description, this.icon, this.display_index);

  factory ThemeApiModel.fromJson(Map<String, dynamic> json) => _$ThemeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeApiModelToJson(this);
}