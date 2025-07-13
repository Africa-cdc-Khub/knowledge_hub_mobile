import 'package:khub_mobile/api/models/category/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  int id;
  String categoryName;
  String categoryDesc;
  String createdAt;
  String updatedAt;

  CategoryModel(
      {required this.id,
      required this.categoryName,
      required this.categoryDesc,
      required this.createdAt,
      required this.updatedAt});

  factory CategoryModel.fromApiModel(CategoryApiModel model) {
    return CategoryModel(
        id: model.id ?? -1,
        categoryName: model.category_name ?? '',
        categoryDesc: model.category_desc ?? '',
        createdAt: model.created_at ?? '',
        updatedAt: model.updated_at ?? '');
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
