// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferenceApiModel _$PreferenceApiModelFromJson(Map<String, dynamic> json) =>
    PreferenceApiModel(
      (json['id'] as num?)?.toInt(),
      json['description'] as String?,
      json['icon'] as String?,
    );

Map<String, dynamic> _$PreferenceApiModelToJson(PreferenceApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
    };
