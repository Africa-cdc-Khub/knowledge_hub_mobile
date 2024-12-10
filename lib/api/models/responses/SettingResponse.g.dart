// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingResponse _$SettingResponseFromJson(Map<String, dynamic> json) =>
    SettingResponse(
      (json['status'] as num?)?.toInt(),
      json['data'] == null
          ? null
          : UserSettingsApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingResponseToJson(SettingResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
