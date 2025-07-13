import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/models/sub_theme_model.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/repository/theme_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class ThemeDetailState {
  bool _loading = false;
  bool _loadingMore = false;
  bool _loadingSubThemes = false;
  String _errorMessage = '';
  int _currentPage = EnvConfig.startPage;
  int _totalPages = 1;
  List<PublicationModel> _publications = [];
  List<SubThemeModel> _subThemes = [];

  bool get loading => _loading;
  bool get loadingSubThemes => _loadingSubThemes;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool _isEndOfPage = false;
  List<PublicationModel> get publications => _publications;
  List<SubThemeModel> get subThemes => _subThemes;
}

class ThemeDetailViewModel extends ChangeNotifier with SafeNotifier {
  final PublicationRepository publicationRepository;
  final ThemeRepository themeRepository;
  ThemeDetailState state = ThemeDetailState();
  ThemeDetailState get getState => state;

  ThemeDetailViewModel(this.publicationRepository, this.themeRepository);

  Future<void> fetchPublications(
      {required int themeId,
      int page = EnvConfig.startPage,
      bool? loadMore = false,
      int? subThemeId}) async {
    if (loadMore != null && !loadMore) {
      state._publications = []; // reset
      state._currentPage = EnvConfig.startPage; // reset
      state._isEndOfPage = false; // reset
    }

    state._loading = state._publications.isEmpty;
    state._loadingMore = state._publications.isNotEmpty;
    safeNotifyListeners();

    try {
      final result = await publicationRepository.fetchPublications(
          themeId: themeId, page: page, subThemeId: subThemeId);

      if (result is DataSuccess) {
        state._totalPages = result.data?.total ?? 1;
        state._publications.addAll(result.data?.data
                ?.map((item) => PublicationModel.fromApiModel(item))
                .toList() ??
            []);
        if (result.data != null &&
            result.data!.data != null &&
            result.data!.data!.isEmpty) {
          state._isEndOfPage = true;
        }
      }

      if (result is DataError) {
        state._errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> loadMore({required int themeId, int? subThemeId}) async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      await fetchPublications(
          themeId: themeId,
          subThemeId: subThemeId,
          loadMore: true,
          page: ++state._currentPage);
    }
  }

  Future<void> fetchSubThemes({required int themeId}) async {
    state._subThemes = [];
    state._loadingSubThemes = true;
    safeNotifyListeners();

    try {
      final result =
          await themeRepository.fetchSubThemesByTheme(themeId: themeId);

      if (result is DataSuccess) {
        state._subThemes = result.data!;
      }

      if (result is DataError) {
        state._loadingSubThemes = false;
        state._errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loadingSubThemes = false;
      safeNotifyListeners();
    }
  }
}
