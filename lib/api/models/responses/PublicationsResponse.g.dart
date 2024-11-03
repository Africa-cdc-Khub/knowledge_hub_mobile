// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PublicationsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicationsResponse _$PublicationsResponseFromJson(
        Map<String, dynamic> json) =>
    PublicationsResponse(
      (json['status'] as num?)?.toInt(),
      (json['page_size'] as num?)?.toInt(),
      (json['total'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => PublicationApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PublicationsResponseToJson(
        PublicationsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'page_size': instance.page_size,
      'total': instance.total,
      'data': instance.data,
    };

PublicationDataResponse _$PublicationDataResponseFromJson(
        Map<String, dynamic> json) =>
    PublicationDataResponse(
      (json['data'] as List<dynamic>?)
          ?.map((e) => PublicationApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PublicationDataResponseToJson(
        PublicationDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
