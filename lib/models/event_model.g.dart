// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      venue: json['venue'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      organizedBy: json['organizedBy'] as String,
      fee: (json['fee'] as num).toDouble(),
      status: json['status'] as String,
      eventLink: json['eventLink'] as String?,
      registrationLink: json['registrationLink'] as String,
      isOnline: (json['isOnline'] as num).toInt(),
      contactPerson: json['contactPerson'] as String,
      bannerImage: json['bannerImage'] as String,
      countryId: (json['countryId'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'venue': instance.venue,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'organizedBy': instance.organizedBy,
      'fee': instance.fee,
      'status': instance.status,
      'eventLink': instance.eventLink,
      'registrationLink': instance.registrationLink,
      'isOnline': instance.isOnline,
      'contactPerson': instance.contactPerson,
      'bannerImage': instance.bannerImage,
      'countryId': instance.countryId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
