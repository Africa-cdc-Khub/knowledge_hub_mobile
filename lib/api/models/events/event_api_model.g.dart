// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventApiModel _$EventApiModelFromJson(Map<String, dynamic> json) =>
    EventApiModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      venue: json['venue'] as String?,
      startdate: json['startdate'] as String?,
      enddate: json['enddate'] as String?,
      organized_by: json['organized_by'] as String?,
      fee: json['fee'] as String?,
      status: json['status'] as String?,
      event_link: json['event_link'] as String?,
      registration_link: json['registration_link'] as String?,
      is_online: (json['is_online'] as num?)?.toInt(),
      contact_person: json['contact_person'] as String?,
      banner_image: json['banner_image'] as String?,
      created_by: json['created_by'] as String?,
      updated_by: json['updated_by'] as String?,
      country_id: (json['country_id'] as num?)?.toInt(),
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$EventApiModelToJson(EventApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'venue': instance.venue,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'organized_by': instance.organized_by,
      'fee': instance.fee,
      'status': instance.status,
      'event_link': instance.event_link,
      'registration_link': instance.registration_link,
      'is_online': instance.is_online,
      'contact_person': instance.contact_person,
      'banner_image': instance.banner_image,
      'created_by': instance.created_by,
      'updated_by': instance.updated_by,
      'country_id': instance.country_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
