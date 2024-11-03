import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/author/author_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentApiModel {
  int? id;
  int? user_id;
  int? created_by;
  int? publication_id;
  int? forum_id;
  String? comment;
  String? created_at;
  String? status;
  AuthorApiModel? user;

  CommentApiModel(this.id, this.user_id, this.publication_id, this.comment,
      this.created_at, this.status, this.user);

  factory CommentApiModel.fromJson(Map<String, dynamic> json) =>
      _$CommentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentApiModelToJson(this);
}
