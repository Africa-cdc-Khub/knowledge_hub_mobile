// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubThemeApiModel _$SubThemeApiModelFromJson(Map<String, dynamic> json) =>
    SubThemeApiModel(
      (json['id'] as num?)?.toInt(),
      json['description'] as String?,
      json['icon'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      (json['thematic_area_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubThemeApiModelToJson(SubThemeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'thematic_area_id': instance.thematic_area_id,
    };
