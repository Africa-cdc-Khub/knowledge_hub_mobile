// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileCategoryModel _$FileCategoryModelFromJson(Map<String, dynamic> json) =>
    FileCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      isDownloadable: (json['isDownloadable'] as num).toInt(),
    );

Map<String, dynamic> _$FileCategoryModelToJson(FileCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'isDownloadable': instance.isDownloadable,
    };
