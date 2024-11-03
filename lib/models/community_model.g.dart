// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: (json['isActive'] as num).toInt(),
      publicationsCount: (json['publicationsCount'] as num).toInt(),
      membersCount: (json['membersCount'] as num).toInt(),
      forumsCount: (json['forumsCount'] as num).toInt(),
      userJoined: json['userJoined'] as bool,
      userPendingApproval: json['userPendingApproval'] as bool,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'publicationsCount': instance.publicationsCount,
      'membersCount': instance.membersCount,
      'forumsCount': instance.forumsCount,
      'userJoined': instance.userJoined,
      'isActive': instance.isActive,
      'userPendingApproval': instance.userPendingApproval,
      'isLoading': instance.isLoading,
    };
