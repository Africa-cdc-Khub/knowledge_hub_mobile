// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityEntity _$CommunityEntityFromJson(Map<String, dynamic> json) =>
    CommunityEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CommunityEntityToJson(CommunityEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
