import 'package:khub_mobile/api/models/forums/forum_model.dart';
import 'package:khub_mobile/models/user_model.dart';

import 'comment_model.dart';

class ForumModel {
  int id;
  String image;
  String title;
  String description;
  String createdAt;
  int createdBy;
  String status;
  int isApproved;
  List<CommentModel>? comments;
  UserModel? user;

  ForumModel(
      {required this.id,
      required this.image,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.createdBy,
      required this.status,
      required this.isApproved,
      required this.comments,
      required this.user});

  factory ForumModel.fromApiModel(ForumApiModel model) {
    return ForumModel(
        id: model.id ?? -1,
        image: model.forum_image ?? '',
        title: model.forum_title ?? '',
        description: model.forum_description ?? '',
        createdAt: model.created_at ?? '',
        comments: model.comments
            ?.map((item) => CommentModel.fromApiModel(item))
            .toList(),
        user: model.user != null ? UserModel.fromApiModel(model.user!) : null,
        createdBy: model.created_by ?? -1,
        status: model.status ?? '',
        isApproved: model.is_approved ?? -1);
  }
}
