// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityApiModel _$CommunityApiModelFromJson(Map<String, dynamic> json) =>
    CommunityApiModel(
      (json['id'] as num?)?.toInt(),
      json['community_name'] as String?,
      json['description'] as String?,
      (json['members_count'] as num?)?.toInt(),
      (json['forums_count'] as num?)?.toInt(),
      (json['publications_count'] as num?)?.toInt(),
      json['user_joined'] as bool?,
      (json['is_active'] as num?)?.toInt(),
      json['user_pending_approval'] as bool?,
    );

Map<String, dynamic> _$CommunityApiModelToJson(CommunityApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'community_name': instance.community_name,
      'description': instance.description,
      'members_count': instance.members_count,
      'forums_count': instance.forums_count,
      'publications_count': instance.publications_count,
      'user_joined': instance.user_joined,
      'is_active': instance.is_active,
      'user_pending_approval': instance.user_pending_approval,
    };
