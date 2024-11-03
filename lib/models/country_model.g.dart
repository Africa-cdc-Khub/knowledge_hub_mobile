// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      national: json['national'] as String,
      isoCode: json['isoCode'] as String,
      phoneCode: json['phoneCode'] as String,
      regionId: (json['regionId'] as num).toInt(),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      color: json['color'] as String,
      baseUrl: json['baseUrl'] as String,
      isAppSupported: (json['isAppSupported'] as num).toInt(),
    );

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'national': instance.national,
      'name': instance.name,
      'isoCode': instance.isoCode,
      'phoneCode': instance.phoneCode,
      'regionId': instance.regionId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'color': instance.color,
      'baseUrl': instance.baseUrl,
      'isAppSupported': instance.isAppSupported,
    };
