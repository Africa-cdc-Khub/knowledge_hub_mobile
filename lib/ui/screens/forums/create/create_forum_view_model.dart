import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/forum_repository.dart';

class CreateForumState {
  final bool _loading = false;
  final bool _isLoggedIn = false;

  bool isSuccess = false;
  String errorMessage = '';
  dynamic response;

  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;

  CreateForumState();
  CreateForumState.success(this.isSuccess, this.response);
  CreateForumState.error(this.isSuccess, this.errorMessage);
}

class CreateForumViewModel extends ChangeNotifier {
  CreateForumState state = CreateForumState();

  CreateForumState get getState => state;

  final ForumRepository forumRepository;

  CreateForumViewModel({required this.forumRepository});

  Future<CreateForumState> submitRequest(
      {required String title, required String description, File? image}) async {
    final result = await forumRepository.createForum(
      title: title,
      description: description,
      image: image,
    );

    if (result is DataSuccess) {
      return CreateForumState.success(true, result.data);
    }

    if (result is DataError) {
      return CreateForumState.error(false, result.error ?? '');
    }

    return CreateForumState();
  }
}
