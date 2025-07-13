// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicationEntity _$PublicationEntityFromJson(Map<String, dynamic> json) =>
    PublicationEntity(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      type: (json['type'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$PublicationEntityToJson(PublicationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'content': instance.content,
    };
