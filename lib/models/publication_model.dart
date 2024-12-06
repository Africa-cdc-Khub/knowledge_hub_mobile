import 'dart:convert';

import 'package:khub_mobile/api/models/publication/publication_model.dart';
import 'package:khub_mobile/cache/models/publication_entity.dart';
import 'package:khub_mobile/models/author_model.dart';
import 'package:khub_mobile/models/category_model.dart';
import 'package:khub_mobile/models/sub_theme_model.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_model.dart';
import 'file_type_model.dart';

part 'publication_model.g.dart';

@JsonSerializable()
class PublicationModel {
  int id;
  int authorId;
  int subThematicAreaId;
  String publication;
  String title;
  String description;
  int publicationCategoryId;
  int geographicalCoverageId;
  String cover;
  String isActive;
  int visits;
  String createdAt;
  String updatedAt;
  int isFeatured;
  int isVideo;
  int isVersion;
  int fileTypeId;
  String citationLink;
  int userId;
  int isApproved;
  int isRejected;
  ThemeModel? theme;
  String label;
  String value;
  bool isFavourite;
  bool hasAttachments;
  List<CommentModel>? comments;
  FileTypeModel? fileType;
  AuthorModel? author;
  SubThemeModel? subTheme;
  CategoryModel? category;
  bool showDisclaimer;

  PublicationModel(
      {required this.id,
      required this.authorId,
      required this.subThematicAreaId,
      required this.publication,
      required this.title,
      required this.description,
      required this.publicationCategoryId,
      required this.geographicalCoverageId,
      required this.cover,
      required this.isActive,
      required this.visits,
      required this.createdAt,
      required this.updatedAt,
      required this.isFeatured,
      required this.isVideo,
      required this.isVersion,
      required this.fileTypeId,
      required this.citationLink,
      required this.userId,
      required this.isApproved,
      required this.isRejected,
      required this.theme,
      required this.label,
      required this.value,
      required this.isFavourite,
      required this.hasAttachments,
      required this.comments,
      required this.fileType,
      required this.author,
      required this.subTheme,
      required this.category,
      required this.showDisclaimer});

  factory PublicationModel.fromApiModel(PublicationApiModel model) {
    return PublicationModel(
        id: model.id ?? -1,
        authorId: model.author_id ?? -1,
        subThematicAreaId: model.sub_thematic_area_id ?? -1,
        publication: model.publication ?? '',
        title: model.title ?? '',
        description: model.description ?? '',
        publicationCategoryId: model.publication_catgory_id ?? -1,
        geographicalCoverageId: model.geographical_coverage_id ?? -1,
        cover: model.cover ?? '',
        isActive: model.is_active ?? '',
        visits: model.visits ?? -1,
        createdAt: model.created_at ?? '',
        updatedAt: model.updated_at ?? '',
        isFeatured: model.is_featured ?? -1,
        isVideo: model.is_video ?? -1,
        isVersion: model.is_version ?? -1,
        fileTypeId: model.file_type_id ?? -1,
        citationLink: model.citation_link ?? '',
        userId: model.user_id ?? -1,
        isApproved: model.is_approved ?? -1,
        isRejected: model.is_rejected ?? -1,
        showDisclaimer: model.show_disclaimer ?? false,
        theme:
            model.theme != null ? ThemeModel.fromApiModel(model.theme!) : null,
        label: model.label ?? '',
        value: model.value ?? '',
        isFavourite: model.is_favourite ?? false,
        hasAttachments: model.has_attachments ?? false,
        comments: model.comments
            ?.map((item) => CommentModel.fromApiModel(item))
            .toList(),
        fileType: model.file_type != null
            ? FileTypeModel.fromApiModel(model.file_type!)
            : null,
        author: model.author != null
            ? AuthorModel.fromApiModel(model.author!)
            : null,
        subTheme: model.sub_theme != null
            ? SubThemeModel.fromApiModel(model.sub_theme!)
            : null,
        category: model.category != null
            ? CategoryModel.fromApiModel(model.category!)
            : null);
  }

  factory PublicationModel.fromJson(Map<String, dynamic> json) =>
      _$PublicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationModelToJson(this);

  factory PublicationModel.fromEntity(PublicationEntity entity) {
    final Map<String, dynamic> modelJson = jsonDecode(entity.content);
    return PublicationModel.fromJson(modelJson);
  }
}
