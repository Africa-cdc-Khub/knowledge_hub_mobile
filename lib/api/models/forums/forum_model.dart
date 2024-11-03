// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/comment/comment_model.dart';
import 'package:khub_mobile/api/models/user/user_api_model.dart';

part 'forum_model.g.dart';

@JsonSerializable()
class ForumApiModel {
  int? id;
  String? forum_image;
  String? forum_title;
  String? forum_description;
  String? created_at;
  int? created_by;
  String? status;
  int? is_approved;
  List<CommentApiModel>? comments;
  UserApiModel? user;

  ForumApiModel({
    this.id,
    this.forum_image,
    this.forum_title,
    this.forum_description,
    this.created_at,
    this.created_by,
    this.status,
    this.is_approved,
    this.comments,
    this.user,
  });

  factory ForumApiModel.fromJson(Map<String, dynamic> json) =>
      _$ForumApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ForumApiModelToJson(this);
}
