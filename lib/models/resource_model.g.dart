// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceTypeModel _$ResourceTypeModelFromJson(Map<String, dynamic> json) =>
    ResourceTypeModel(
      id: (json['id'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      showOnMenu: (json['showOnMenu'] as num).toInt(),
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ResourceTypeModelToJson(ResourceTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryName': instance.categoryName,
      'showOnMenu': instance.showOnMenu,
      'slug': instance.slug,
    };

ResourceCategoryModel _$ResourceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ResourceCategoryModel(
      id: (json['id'] as num).toInt(),
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$ResourceCategoryModelToJson(
        ResourceCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryName': instance.categoryName,
    };
