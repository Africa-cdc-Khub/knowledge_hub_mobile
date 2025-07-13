import 'package:khub_mobile/api/models/comment/comment_model.dart';
import 'package:khub_mobile/models/author_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  int id;
  int userId;
  int publicationId;
  int forumId;
  String comment;
  String createdAt;
  String status;
  int createdBy;
  AuthorModel? user;

  CommentModel(
      {required this.id,
      required this.userId,
      required this.createdBy,
      required this.publicationId,
      required this.forumId,
      required this.comment,
      required this.createdAt,
      required this.status,
      required this.user});

  factory CommentModel.fromApiModel(CommentApiModel model) {
    return CommentModel(
        id: model.id ?? -1,
        userId: model.user_id ?? -1,
        createdBy: model.created_by ?? -1,
        publicationId: model.publication_id ?? -1,
        forumId: model.forum_id ?? -1,
        comment: model.comment ?? '',
        createdAt: model.created_at ?? '',
        status: model.status ?? '',
        user:
            model.user != null ? AuthorModel.fromApiModel(model.user!) : null);
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
