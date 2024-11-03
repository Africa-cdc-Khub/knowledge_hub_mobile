// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThemesResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemesResponse _$ThemesResponseFromJson(Map<String, dynamic> json) =>
    ThemesResponse(
      (json['status'] as num?)?.toInt(),
      json['data'] == null
          ? null
          : ThemeDataResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThemesResponseToJson(ThemesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

ThemeDataResponse _$ThemeDataResponseFromJson(Map<String, dynamic> json) =>
    ThemeDataResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => ThemeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThemeDataResponseToJson(ThemeDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
