import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/author/author_model.dart';
import 'package:khub_mobile/api/models/category/category_model.dart';
import 'package:khub_mobile/api/models/comment/comment_model.dart';
import 'package:khub_mobile/api/models/fileType/file_type_model.dart';
import 'package:khub_mobile/api/models/subTheme/sub_theme_model.dart';
import 'package:khub_mobile/api/models/theme/theme_model.dart';

part 'publication_model.g.dart';

@JsonSerializable()
class PublicationApiModel {
  int? id;
  int? author_id;
  int? sub_thematic_area_id;
  String? publication;
  String? title;
  String? description;
  int? publication_catgory_id;
  int? geographical_coverage_id;
  String? cover;
  String? is_active;
  int? visits;
  String? created_at;
  String? updated_at;
  int? is_featured;
  int? is_video;
  int? is_version;
  int? file_type_id;
  String? citation_link;
  int? user_id;
  int? is_approved;
  int? is_rejected;
  ThemeApiModel? theme;
  String? label;
  String? value;
  bool? is_favourite;
  // List<dynamic>? approved_comments;
  List<CommentApiModel>? comments;
  bool? has_attachments;
  FileTypeApiModel? file_type;
  AuthorApiModel? author;
  SubThemeApiModel? sub_theme;
  CategoryApiModel? category;
  int? show_disclaimer;

  PublicationApiModel(
      this.id,
      this.author_id,
      this.sub_thematic_area_id,
      this.publication,
      this.title,
      this.description,
      this.publication_catgory_id,
      this.geographical_coverage_id,
      this.cover,
      this.is_active,
      this.visits,
      this.created_at,
      this.updated_at,
      this.is_featured,
      this.is_video,
      this.is_version,
      this.file_type_id,
      this.citation_link,
      this.user_id,
      this.is_approved,
      this.is_rejected,
      this.theme,
      this.label,
      this.value,
      this.is_favourite,
      this.comments,
      this.has_attachments,
      this.file_type,
      this.author,
      this.sub_theme,
      this.category,
      this.show_disclaimer);

  factory PublicationApiModel.fromJson(Map<String, dynamic> json) =>
      _$PublicationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationApiModelToJson(this);

  // factory PublicationApiModel.toModel() {
  //  return PublicationEntity(
  //      id, this.id ?? -1,
  //      authorId, subThematicAreaId, publication, title, description, publicationCatgoryId, geographicalCoverageId, cover, isActive, visits, createdAt, updatedAt, isFeatured, isVideo, isVersion, fileTypeId, citationLink, userId, isApproved, isRejected, theme, label, value, isFavourite, hasAttachments, fileType, author, subTheme, category)
  // }
}
