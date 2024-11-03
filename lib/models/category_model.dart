import 'package:khub_mobile/api/models/category/category_model.dart';

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
}
