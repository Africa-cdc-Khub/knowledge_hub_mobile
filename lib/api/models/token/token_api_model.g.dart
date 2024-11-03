// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenApiModel _$TokenApiModelFromJson(Map<String, dynamic> json) =>
    TokenApiModel(
      json['token_type'] as String?,
      json['expires_at'] as String?,
      json['token'] as String?,
      json['refresh_token'] as String?,
      json['user'] == null
          ? null
          : UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenApiModelToJson(TokenApiModel instance) =>
    <String, dynamic>{
      'token_type': instance.token_type,
      'expires_at': instance.expires_at,
      'token': instance.token,
      'refresh_token': instance.refresh_token,
      'user': instance.user,
    };
