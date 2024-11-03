// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobApiModel _$JobApiModelFromJson(Map<String, dynamic> json) => JobApiModel(
      (json['id'] as num?)?.toInt(),
      (json['job_id'] as num?)?.toInt(),
      (json['classification_id'] as num?)?.toInt(),
      (json['isco_id'] as num?)?.toInt(),
      json['name'] as String?,
    );

Map<String, dynamic> _$JobApiModelToJson(JobApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'job_id': instance.job_id,
      'classification_id': instance.classification_id,
      'isco_id': instance.isco_id,
      'name': instance.name,
    };
