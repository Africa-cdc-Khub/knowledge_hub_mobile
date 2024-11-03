// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
      id: (json['id'] as num).toInt(),
      moodleId: (json['moodleId'] as num).toInt(),
      fullname: json['fullname'] as String,
      shortname: json['shortname'] as String,
      coverImage: json['coverImage'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      summary: json['summary'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      courseLink: json['courseLink'] as String,
    );

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moodleId': instance.moodleId,
      'fullname': instance.fullname,
      'shortname': instance.shortname,
      'coverImage': instance.coverImage,
      'categoryId': instance.categoryId,
      'summary': instance.summary,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'courseLink': instance.courseLink,
    };
