// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubThemeModel _$SubThemeModelFromJson(Map<String, dynamic> json) =>
    SubThemeModel(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      thematicAreaId: (json['thematicAreaId'] as num).toInt(),
    );

Map<String, dynamic> _$SubThemeModelToJson(SubThemeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'thematicAreaId': instance.thematicAreaId,
    };
