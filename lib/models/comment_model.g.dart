// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      createdBy: (json['createdBy'] as num).toInt(),
      publicationId: (json['publicationId'] as num).toInt(),
      forumId: (json['forumId'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
      status: json['status'] as String,
      user: json['user'] == null
          ? null
          : AuthorModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'publicationId': instance.publicationId,
      'forumId': instance.forumId,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'status': instance.status,
      'createdBy': instance.createdBy,
      'user': instance.user,
    };
