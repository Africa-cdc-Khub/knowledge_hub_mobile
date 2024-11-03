// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesResponse _$CoursesResponseFromJson(Map<String, dynamic> json) =>
    CoursesResponse(
      (json['status'] as num?)?.toInt(),
      (json['page_size'] as num?)?.toInt(),
      (json['total'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => CourseApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CoursesResponseToJson(CoursesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'page_size': instance.page_size,
      'total': instance.total,
      'data': instance.data,
    };

CourseApiModel _$CourseApiModelFromJson(Map<String, dynamic> json) =>
    CourseApiModel(
      (json['id'] as num?)?.toInt(),
      (json['moodle_id'] as num?)?.toInt(),
      json['fullname'] as String?,
      json['shortname'] as String?,
      json['cover_image'] as String?,
      (json['category_id'] as num?)?.toInt(),
      json['summary'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['course_link'] as String?,
    );

Map<String, dynamic> _$CourseApiModelToJson(CourseApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moodle_id': instance.moodle_id,
      'fullname': instance.fullname,
      'shortname': instance.shortname,
      'cover_image': instance.cover_image,
      'category_id': instance.category_id,
      'summary': instance.summary,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'course_link': instance.course_link,
    };
