import 'package:flutter/foundation.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class PublicationListState {
  bool _loading = false;
  String _errorMessage = '';
  int _currentPage = EnvConfig.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;
  List<PublicationModel> _publications = [];
  int _errorType = 2;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<PublicationModel> get publications => _publications;
  int get errorType => _errorType;
}

class PublicationListViewModel extends ChangeNotifier with SafeNotifier {
  final PublicationRepository publicationRepository;
  final ConnectionRepository connectionRepository;
  PublicationListState state = PublicationListState();
  PublicationListState get getState => state;

  PublicationListViewModel(
      this.publicationRepository, this.connectionRepository);

  Future<bool> _checkInternetConnection() async {
    final isConnected = await connectionRepository.checkInternetStatus();
    state._errorMessage = isConnected ? '' : 'No internet connection';
    if (!isConnected) {
      state._errorType = 1;
      safeNotifyListeners();
    }
    return isConnected;
  }

  Future<void> addFavorite(int publicationId) async {
    try {
      if (state._publications.isNotEmpty) {
        // Find and update the publication's favorite status
        final index =
            state._publications.indexWhere((pub) => pub.id == publicationId);
        if (index != -1) {
          state._publications[index].isFavourite = true;
          safeNotifyListeners();
        }

        await publicationRepository.addFavoritePublication(
            publicationId: publicationId);
      }
    } on Exception catch (e) {
      LOGGER.e(e);
    }
  }

  Future<void> fetchPublications(
      {int page = EnvConfig.startPage,
      bool? isFeatured,
      bool? orderByVisits,
      int? categoryId}) async {
    state._loading = true;
    state._publications = []; // reset
    state._currentPage = EnvConfig.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
      final isConnected = await _checkInternetConnection();
      if (!isConnected) {
        return;
      }

      final result = await publicationRepository.fetchPublications(
          page: page,
          isFeatured: isFeatured,
          orderByVisits: orderByVisits,
          categoryId: categoryId);

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
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> loadMore(
      {bool? isFeatured, bool? orderByVisits, int? categoryId}) async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final isConnected = await _checkInternetConnection();
        if (!isConnected) {
          return;
        }

        final result = await publicationRepository.fetchPublications(
            page: ++state._currentPage,
            isFeatured: isFeatured,
            orderByVisits: orderByVisits,
            categoryId: categoryId);

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
      } finally {
        state._loading = false;
        safeNotifyListeners();
      }
    }
  }
}
