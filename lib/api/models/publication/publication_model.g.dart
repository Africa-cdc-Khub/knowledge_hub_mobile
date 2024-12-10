// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicationApiModel _$PublicationApiModelFromJson(Map<String, dynamic> json) =>
    PublicationApiModel(
      (json['id'] as num?)?.toInt(),
      (json['author_id'] as num?)?.toInt(),
      (json['sub_thematic_area_id'] as num?)?.toInt(),
      json['publication'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      (json['publication_catgory_id'] as num?)?.toInt(),
      (json['geographical_coverage_id'] as num?)?.toInt(),
      json['cover'] as String?,
      json['is_active'] as String?,
      (json['visits'] as num?)?.toInt(),
      json['created_at'] as String?,
      json['updated_at'] as String?,
      (json['is_featured'] as num?)?.toInt(),
      (json['is_video'] as num?)?.toInt(),
      (json['is_version'] as num?)?.toInt(),
      (json['file_type_id'] as num?)?.toInt(),
      json['citation_link'] as String?,
      (json['user_id'] as num?)?.toInt(),
      (json['is_approved'] as num?)?.toInt(),
      (json['is_rejected'] as num?)?.toInt(),
      json['theme'] == null
          ? null
          : ThemeApiModel.fromJson(json['theme'] as Map<String, dynamic>),
      json['label'] as String?,
      json['value'] as String?,
      json['is_favourite'] as bool?,
      (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['has_attachments'] as bool?,
      json['file_type'] == null
          ? null
          : FileTypeApiModel.fromJson(
              json['file_type'] as Map<String, dynamic>),
      json['author'] == null
          ? null
          : AuthorApiModel.fromJson(json['author'] as Map<String, dynamic>),
      json['sub_theme'] == null
          ? null
          : SubThemeApiModel.fromJson(
              json['sub_theme'] as Map<String, dynamic>),
      json['category'] == null
          ? null
          : CategoryApiModel.fromJson(json['category'] as Map<String, dynamic>),
      (json['show_disclaimer'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PublicationApiModelToJson(
        PublicationApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.author_id,
      'sub_thematic_area_id': instance.sub_thematic_area_id,
      'publication': instance.publication,
      'title': instance.title,
      'description': instance.description,
      'publication_catgory_id': instance.publication_catgory_id,
      'geographical_coverage_id': instance.geographical_coverage_id,
      'cover': instance.cover,
      'is_active': instance.is_active,
      'visits': instance.visits,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'is_featured': instance.is_featured,
      'is_video': instance.is_video,
      'is_version': instance.is_version,
      'file_type_id': instance.file_type_id,
      'citation_link': instance.citation_link,
      'user_id': instance.user_id,
      'is_approved': instance.is_approved,
      'is_rejected': instance.is_rejected,
      'theme': instance.theme,
      'label': instance.label,
      'value': instance.value,
      'is_favourite': instance.is_favourite,
      'comments': instance.comments,
      'has_attachments': instance.has_attachments,
      'file_type': instance.file_type,
      'author': instance.author,
      'sub_theme': instance.sub_theme,
      'category': instance.category,
      'show_disclaimer': instance.show_disclaimer,
    };
