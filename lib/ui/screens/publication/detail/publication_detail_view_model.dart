import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/comment_model.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/models/settings_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';
import 'package:khub_mobile/utils/helpers.dart';

class PublicationDetailState {
  final bool _loading = false;
  final String _errorMessage = '';
  PublicationModel? _publication;
  UserModel? _currentUser;
  SettingsModel? _appSettings;

  bool get loading => _loading;

  String get errorMessage => _errorMessage;

  PublicationModel? get publication => _publication;

  UserModel? get currentUser => _currentUser;

  SettingsModel? get appSettings => _appSettings;
}

class PublicationDetailViewModel extends ChangeNotifier with SafeNotifier {
  PublicationDetailState state = PublicationDetailState();

  PublicationDetailState get getState => state;

  final AuthRepository authRepository;
  final PublicationRepository publicationRepository;
  final UtilityDatasource utilityDatasource;

  PublicationDetailViewModel(
      this.authRepository, this.publicationRepository, this.utilityDatasource);

  void setCurrentPublication(PublicationModel model) {
    state._publication = model;
    safeNotifyListeners();
  }

  Future<bool?> getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    state._currentUser = user;
    safeNotifyListeners();
    return Future.value(user != null);
  }

  Future<bool?> getAppSettings() async {
    final settings = await utilityDatasource.getSettings();
    if (settings.isNotEmpty) {
      state._appSettings = settings[0];
    }
    safeNotifyListeners();
    return Future.value(settings.isNotEmpty);
  }

  Future<void> addComment(String comment) async {
    try {
      if (state._publication != null) {
        final existingComments = state._publication!.comments;

        if (existingComments != null) {
          final newComment = CommentModel(
              id: Helpers.getRandomNumber(),
              userId: state._currentUser!.id,
              createdBy: state._currentUser!.id,
              publicationId: state._publication!.id,
              forumId: -1,
              comment: comment,
              createdAt: Helpers.getCurrentDateTime(),
              status: 'pending',
              user: null);

          state._publication!.comments!.add(newComment);
          safeNotifyListeners();

          await publicationRepository.addPublicationComment(
              publicationId: state._publication!.id, comment: comment);
        }
      }
    } on Exception catch (e) {
      LOGGER.e(e);
    }
  }

  Future<void> addFavorite(int publicationId) async {
    try {
      if (state._publication != null) {
        state._publication!.isFavourite = true;
        safeNotifyListeners();

        await publicationRepository.addFavoritePublication(
            publicationId: publicationId);
      }
    } on Exception catch (e) {
      LOGGER.e(e);
    }
  }
}
