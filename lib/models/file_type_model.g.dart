// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileTypeModel _$FileTypeModelFromJson(Map<String, dynamic> json) =>
    FileTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      isDownloadable: (json['isDownloadable'] as num).toInt(),
    );

Map<String, dynamic> _$FileTypeModelToJson(FileTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'isDownloadable': instance.isDownloadable,
    };
