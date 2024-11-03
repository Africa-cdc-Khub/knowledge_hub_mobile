// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UtilityResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileTypeResponse _$FileTypeResponseFromJson(Map<String, dynamic> json) =>
    FileTypeResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => FileTypeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileTypeResponseToJson(FileTypeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

FileCategoryResponse _$FileCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    FileCategoryResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => FileTypeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileCategoryResponseToJson(
        FileCategoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

PreferenceResponse _$PreferenceResponseFromJson(Map<String, dynamic> json) =>
    PreferenceResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => PreferenceApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreferenceResponseToJson(PreferenceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

JobResponse _$JobResponseFromJson(Map<String, dynamic> json) => JobResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => JobApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JobResponseToJson(JobResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

CommunityResponse _$CommunityResponseFromJson(Map<String, dynamic> json) =>
    CommunityResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => CommunityApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommunityResponseToJson(CommunityResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'total': instance.total,
    };

CountryResponse _$CountryResponseFromJson(Map<String, dynamic> json) =>
    CountryResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => CountryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryResponseToJson(CountryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

ResourceTypeResponse _$ResourceTypeResponseFromJson(
        Map<String, dynamic> json) =>
    ResourceTypeResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => ResourceTypeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResourceTypeResponseToJson(
        ResourceTypeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

ResourceCategoryResponse _$ResourceCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    ResourceCategoryResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
              ResourceCategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResourceCategoryResponseToJson(
        ResourceCategoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
