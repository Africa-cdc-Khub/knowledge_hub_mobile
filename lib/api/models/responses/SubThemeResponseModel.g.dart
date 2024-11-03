// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubThemeResponseModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubThemeResponse _$SubThemeResponseFromJson(Map<String, dynamic> json) =>
    SubThemeResponse(
      (json['status'] as num?)?.toInt(),
      json['data'] == null
          ? null
          : SubThemeDataResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubThemeResponseToJson(SubThemeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

SubThemeDataResponse _$SubThemeDataResponseFromJson(
        Map<String, dynamic> json) =>
    SubThemeDataResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => SubThemeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubThemeDataResponseToJson(
        SubThemeDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
