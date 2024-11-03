// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileTypeApiModel _$FileTypeApiModelFromJson(Map<String, dynamic> json) =>
    FileTypeApiModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['icon'] as String?,
      (json['is_downloadable'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FileTypeApiModelToJson(FileTypeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'is_downloadable': instance.is_downloadable,
    };
