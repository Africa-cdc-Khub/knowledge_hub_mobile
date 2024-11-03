// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ForumsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumsResponse _$ForumsResponseFromJson(Map<String, dynamic> json) =>
    ForumsResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => ForumApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ForumsResponseToJson(ForumsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
      'data': instance.data,
    };
