import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/comment_model.dart';
import 'package:khub_mobile/models/forum_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/forum_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';
import 'package:khub_mobile/utils/helpers.dart';

class ForumDetailState {
  final bool _loading = false;
  final String _errorMessage = '';
  ForumModel? _forum;
  UserModel? _currentUser;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  ForumModel? get forum => _forum;
  UserModel? get currentUser => _currentUser;
}

class ForumDetailViewModel extends ChangeNotifier with SafeNotifier {
  ForumDetailState state = ForumDetailState();

  ForumDetailState get getState => state;

  final AuthRepository authRepository;
  final ForumRepository forumRepository;

  ForumDetailViewModel(this.authRepository, this.forumRepository);

  void setCurrentForum(ForumModel model) {
    state._forum = model;
    safeNotifyListeners();
  }

  Future<bool?> getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    state._currentUser = user;
    safeNotifyListeners();
    return Future.value(user != null);
  }

  Future<void> addComment(String comment) async {
    try {
      if (state._forum != null) {
        final existingComments = state._forum!.comments;

        if (existingComments != null) {
          final newComment = CommentModel(
              id: Helpers.getRandomNumber(),
              userId: state._currentUser!.id,
              createdBy: state._currentUser!.id,
              forumId: state._forum!.id,
              publicationId: state._forum!.id,
              comment: comment,
              createdAt: Helpers.getCurrentDateTime(),
              status: 'pending',
              user: null);

          state._forum!.comments!.add(newComment);
          safeNotifyListeners();

          await forumRepository.addForumComment(
              forumId: state._forum!.id, comment: comment);
        }
      }
    } on Exception catch (e) {
      LOGGER.e(e);
    }
  }
}
