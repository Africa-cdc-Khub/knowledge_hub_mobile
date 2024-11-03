// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceTypeApiModel _$ResourceTypeApiModelFromJson(
        Map<String, dynamic> json) =>
    ResourceTypeApiModel(
      id: (json['id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      show_on_menu: (json['show_on_menu'] as num?)?.toInt(),
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$ResourceTypeApiModelToJson(
        ResourceTypeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.category_name,
      'show_on_menu': instance.show_on_menu,
      'slug': instance.slug,
    };

ResourceCategoryApiModel _$ResourceCategoryApiModelFromJson(
        Map<String, dynamic> json) =>
    ResourceCategoryApiModel(
      id: (json['id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
    );

Map<String, dynamic> _$ResourceCategoryApiModelToJson(
        ResourceCategoryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.category_name,
    };
