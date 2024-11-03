// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsResponse _$NotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationsResponse(
      (json['status'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationsResponseToJson(
        NotificationsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
      'data': instance.data,
    };

UnreadNotificationResponse _$UnreadNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    UnreadNotificationResponse(
      (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnreadNotificationResponseToJson(
        UnreadNotificationResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
    };
