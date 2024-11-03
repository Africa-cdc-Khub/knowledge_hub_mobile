// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumApiModel _$ForumApiModelFromJson(Map<String, dynamic> json) =>
    ForumApiModel(
      id: (json['id'] as num?)?.toInt(),
      forum_image: json['forum_image'] as String?,
      forum_title: json['forum_title'] as String?,
      forum_description: json['forum_description'] as String?,
      created_at: json['created_at'] as String?,
      created_by: (json['created_by'] as num?)?.toInt(),
      status: json['status'] as String?,
      is_approved: (json['is_approved'] as num?)?.toInt(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForumApiModelToJson(ForumApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'forum_image': instance.forum_image,
      'forum_title': instance.forum_title,
      'forum_description': instance.forum_description,
      'created_at': instance.created_at,
      'created_by': instance.created_by,
      'status': instance.status,
      'is_approved': instance.is_approved,
      'comments': instance.comments,
      'user': instance.user,
    };
