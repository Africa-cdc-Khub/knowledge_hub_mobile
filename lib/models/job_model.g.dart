// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      id: (json['id'] as num).toInt(),
      jobId: (json['jobId'] as num).toInt(),
      classificationId: (json['classificationId'] as num).toInt(),
      iscoId: (json['iscoId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'classificationId': instance.classificationId,
      'iscoId': instance.iscoId,
      'name': instance.name,
    };
