// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeApiModel _$ThemeApiModelFromJson(Map<String, dynamic> json) =>
    ThemeApiModel(
      (json['id'] as num?)?.toInt(),
      json['description'] as String?,
      json['icon'] as String?,
      (json['display_index'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ThemeApiModelToJson(ThemeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
      'display_index': instance.display_index,
    };
