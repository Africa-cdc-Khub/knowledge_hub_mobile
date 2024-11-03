// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorApiModel _$AuthorApiModelFromJson(Map<String, dynamic> json) =>
    AuthorApiModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['icon'] as String?,
      json['is_organsiation'] as String?,
      json['address'] as String?,
      json['telephone'] as String?,
      json['email'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['logo'] as String?,
    );

Map<String, dynamic> _$AuthorApiModelToJson(AuthorApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'is_organsiation': instance.is_organsiation,
      'address': instance.address,
      'telephone': instance.telephone,
      'email': instance.email,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'logo': instance.logo,
    };
