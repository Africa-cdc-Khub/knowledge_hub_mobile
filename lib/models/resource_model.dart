import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/resource/resource_api_model.dart';

part 'resource_model.g.dart';

@JsonSerializable()
class ResourceTypeModel {
  int id;
  String categoryName;
  int showOnMenu;
  String slug;

  ResourceTypeModel({
    required this.id,
    required this.categoryName,
    required this.showOnMenu,
    required this.slug,
  });

  factory ResourceTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceTypeModelToJson(this);

  factory ResourceTypeModel.fromApiModel(ResourceTypeApiModel model) {
    return ResourceTypeModel(
      id: model.id ?? -1,
      categoryName: model.category_name ?? '',
      showOnMenu: model.show_on_menu ?? -1,
      slug: model.slug ?? '',
    );
  }
}

@JsonSerializable()
class ResourceCategoryModel {
  int id;
  String categoryName;

  ResourceCategoryModel({required this.id, required this.categoryName});

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceCategoryModelToJson(this);

  factory ResourceCategoryModel.fromApiModel(ResourceCategoryApiModel model) {
    return ResourceCategoryModel(
        id: model.id ?? -1, categoryName: model.category_name ?? '');
  }
}
