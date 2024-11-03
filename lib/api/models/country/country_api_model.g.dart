// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryApiModel _$CountryApiModelFromJson(Map<String, dynamic> json) =>
    CountryApiModel(
      (json['id'] as num?)?.toInt(),
      json['national'] as String?,
      json['name'] as String?,
      json['iso_code'] as String?,
      json['phonecode'] as String?,
      (json['region_id'] as num?)?.toInt(),
      (json['longitude'] as num?)?.toDouble(),
      (json['latitude'] as num?)?.toDouble(),
      json['color'] as String?,
      json['base_url'] as String?,
      (json['is_app_supported'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CountryApiModelToJson(CountryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'national': instance.national,
      'name': instance.name,
      'iso_code': instance.iso_code,
      'phonecode': instance.phonecode,
      'region_id': instance.region_id,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'color': instance.color,
      'base_url': instance.base_url,
      'is_app_supported': instance.is_app_supported,
    };
