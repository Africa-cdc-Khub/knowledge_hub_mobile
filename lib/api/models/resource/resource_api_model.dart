import 'package:json_annotation/json_annotation.dart';

part 'resource_api_model.g.dart';

@JsonSerializable()
class ResourceTypeApiModel {
  int? id;
  String? category_name;
  int? show_on_menu;
  String? slug;

  ResourceTypeApiModel({
    this.id,
    this.category_name,
    this.show_on_menu,
    this.slug,
  });

  factory ResourceTypeApiModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceTypeApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceTypeApiModelToJson(this);
}

// resource category
// "id": 5,
//       "category_name": "Web System",
//       "category_desc": null,
//       "created_at": null,
//       "updated_at": null

@JsonSerializable()
class ResourceCategoryApiModel {
  int? id;
  String? category_name;

  ResourceCategoryApiModel({
    this.id,
    this.category_name,
  });

  factory ResourceCategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceCategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceCategoryApiModelToJson(this);
}
