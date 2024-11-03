// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      (json['id'] as num?)?.toInt(),
      json['category_name'] as String?,
      json['category_desc'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.category_name,
      'category_desc': instance.category_desc,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
