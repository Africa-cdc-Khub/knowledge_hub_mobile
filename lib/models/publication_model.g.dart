// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicationModel _$PublicationModelFromJson(Map<String, dynamic> json) =>
    PublicationModel(
      id: (json['id'] as num).toInt(),
      authorId: (json['authorId'] as num).toInt(),
      subThematicAreaId: (json['subThematicAreaId'] as num).toInt(),
      publication: json['publication'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      publicationCategoryId: (json['publicationCategoryId'] as num).toInt(),
      geographicalCoverageId: (json['geographicalCoverageId'] as num).toInt(),
      cover: json['cover'] as String,
      isActive: json['isActive'] as String,
      visits: (json['visits'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isFeatured: (json['isFeatured'] as num).toInt(),
      isVideo: (json['isVideo'] as num).toInt(),
      isVersion: (json['isVersion'] as num).toInt(),
      fileTypeId: (json['fileTypeId'] as num).toInt(),
      citationLink: json['citationLink'] as String,
      userId: (json['userId'] as num).toInt(),
      isApproved: (json['isApproved'] as num).toInt(),
      isRejected: (json['isRejected'] as num).toInt(),
      theme: json['theme'] == null
          ? null
          : ThemeModel.fromJson(json['theme'] as Map<String, dynamic>),
      label: json['label'] as String,
      value: json['value'] as String,
      isFavourite: json['isFavourite'] as bool,
      hasAttachments: json['hasAttachments'] as bool,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      fileType: json['fileType'] == null
          ? null
          : FileTypeModel.fromJson(json['fileType'] as Map<String, dynamic>),
      author: json['author'] == null
          ? null
          : AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
      subTheme: json['subTheme'] == null
          ? null
          : SubThemeModel.fromJson(json['subTheme'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      showDisclaimer: json['showDisclaimer'] as bool,
    );

Map<String, dynamic> _$PublicationModelToJson(PublicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'subThematicAreaId': instance.subThematicAreaId,
      'publication': instance.publication,
      'title': instance.title,
      'description': instance.description,
      'publicationCategoryId': instance.publicationCategoryId,
      'geographicalCoverageId': instance.geographicalCoverageId,
      'cover': instance.cover,
      'isActive': instance.isActive,
      'visits': instance.visits,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isFeatured': instance.isFeatured,
      'isVideo': instance.isVideo,
      'isVersion': instance.isVersion,
      'fileTypeId': instance.fileTypeId,
      'citationLink': instance.citationLink,
      'userId': instance.userId,
      'isApproved': instance.isApproved,
      'isRejected': instance.isRejected,
      'theme': instance.theme,
      'label': instance.label,
      'value': instance.value,
      'isFavourite': instance.isFavourite,
      'hasAttachments': instance.hasAttachments,
      'comments': instance.comments,
      'fileType': instance.fileType,
      'author': instance.author,
      'subTheme': instance.subTheme,
      'category': instance.category,
      'showDisclaimer': instance.showDisclaimer,
    };
