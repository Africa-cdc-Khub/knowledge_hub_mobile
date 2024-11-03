// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) => ThemeModel(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      displayIndex: (json['displayIndex'] as num).toInt(),
    );

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
      'displayIndex': instance.displayIndex,
    };
