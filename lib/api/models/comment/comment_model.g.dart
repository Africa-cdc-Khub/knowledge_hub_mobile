// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentApiModel _$CommentApiModelFromJson(Map<String, dynamic> json) =>
    CommentApiModel(
      (json['id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      (json['publication_id'] as num?)?.toInt(),
      json['comment'] as String?,
      json['created_at'] as String?,
      json['status'] as String?,
      json['user'] == null
          ? null
          : AuthorApiModel.fromJson(json['user'] as Map<String, dynamic>),
    )
      ..created_by = (json['created_by'] as num?)?.toInt()
      ..forum_id = (json['forum_id'] as num?)?.toInt();

Map<String, dynamic> _$CommentApiModelToJson(CommentApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'created_by': instance.created_by,
      'publication_id': instance.publication_id,
      'forum_id': instance.forum_id,
      'comment': instance.comment,
      'created_at': instance.created_at,
      'status': instance.status,
      'user': instance.user,
    };
