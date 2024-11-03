import 'package:khub_mobile/api/models/publication/publication_model.dart';
import 'package:khub_mobile/models/author_model.dart';
import 'package:khub_mobile/models/category_model.dart';
import 'package:khub_mobile/models/sub_theme_model.dart';
import 'package:khub_mobile/models/theme_model.dart';

import 'comment_model.dart';
import 'file_type_model.dart';

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

  PublicationModel({required this.id,
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
    required this.category});

  factory PublicationModel.fromApiModel(PublicationApiModel model) {
    final m = model.comments?.map((item) => CommentModel.fromApiModel(item)).toList() ?? [];

    return PublicationModel(
        id: model.id ?? -1,
        authorId: model.author_id ?? -1,
        subThematicAreaId: model.sub_thematic_area_id ?? -1,
        publication: model.publication ?? '',
        title: model.title ?? '',
        description: model.description ?? '',
        publicationCategoryId: model.publication_catgory_id ?? -1,
        geographicalCoverageId: model.geographical_coverage_id  ?? -1,
        cover: model.cover ?? '',
        isActive: model.is_active ?? '',
        visits: model.visits ?? -1,
        createdAt: model.created_at  ?? '',
        updatedAt: model.updated_at ?? '',
        isFeatured: model.is_featured ?? -1,
        isVideo: model.is_video ?? -1,
        isVersion: model.is_version ?? -1,
        fileTypeId: model.file_type_id ?? -1,
        citationLink: model.citation_link ?? '',
        userId: model.user_id ?? -1,
        isApproved: model.is_approved ?? -1,
        isRejected: model.is_rejected ?? -1,
        theme: model.theme != null ? ThemeModel.fromApiModel(model.theme!) : null,
        label: model.label ?? '',
        value: model.value ?? '',
        isFavourite: model.is_favourite  ?? false,
        hasAttachments: model.has_attachments ?? false,
        comments: model.comments?.map((item) => CommentModel.fromApiModel(item)).toList(),
        fileType: model.file_type != null ? FileTypeModel.fromApiModel(model.file_type!) : null,
        author: model.author != null ? AuthorModel.fromApiModel(model.author!) : null,
        subTheme: model.sub_theme != null ? SubThemeModel.fromApiModel(model.sub_theme!) : null,
        category: model.category != null ? CategoryModel.fromApiModel(model.category!) : null);
  }
}
