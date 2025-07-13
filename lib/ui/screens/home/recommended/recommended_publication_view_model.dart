import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/PublicationsResponse.dart';
import 'package:khub_mobile/cache/models/publication_entity.dart';
import 'package:khub_mobile/cache/publication_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class RecommendedPublicationState {
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

  // RecommendedPublicationState();
  // RecommendedPublicationState.success(this.isSuccess, this.publications);
  // RecommendedPublicationState.error(
  //     this.isSuccess, this.errorMessage, this.errorType);
}

class RecommendedPublicationViewModel extends ChangeNotifier with SafeNotifier {
  final PublicationRepository publicationRepository;
  final ConnectionRepository connectionRepository;
  final PublicationDataSource publicationDataSource;

  RecommendedPublicationState state = RecommendedPublicationState();
  // HomeState get getState => state;

  RecommendedPublicationViewModel(this.publicationRepository,
      this.connectionRepository, this.publicationDataSource);

  Future<bool> _checkInternetConnection() async {
    final isConnected = await connectionRepository.checkInternetStatus();
    state._errorMessage = isConnected ? '' : 'No internet connection';
    if (!isConnected) {
      state._errorType = 1;
      safeNotifyListeners();
    }
    return isConnected;
  }

  Future<void> fetchPublications(
      {int page = 1, bool? isFeatured}) async {
    state._loading = true;
    state._publications = []; // reset
    state._currentPage = EnvConfig.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
      final isConnected = await _checkInternetConnection();
      if (!isConnected) {
        state._publications = await _getPublicationsFromCache();
        safeNotifyListeners();
      }

      await _getRemotePublications(page, isFeatured);

    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> clearPublicationsFromCache() async {
    await publicationDataSource.deletePublications(0);
  }

  Future<void> savePublicationsToCache(
      List<PublicationModel> publications) async {
    final list = publications
        .map((item) => PublicationEntity.fromModel(item, 0))
        .toList();
    await publicationDataSource.savePublications(list);
  }

  Future<DataState<PublicationsResponse>> _fetchRemotePublications(
      int page, bool? isFeatured) async {
    final result = await publicationRepository.fetchPublications(
        page: page, isFeatured: isFeatured ?? false);

    if (result is DataSuccess) {
      final list = result.data?.data
              ?.map((item) => PublicationModel.fromApiModel(item))
              .toList() ??
          [];

      if(page == 1) {
        await clearPublicationsFromCache(); // Clear existing
        savePublicationsToCache(list); // Save new events
      }
    }
    return result;
  }

  Future<void> _getRemotePublications(
      int page, bool? isFeatured) async {

    final result = await _fetchRemotePublications(page, isFeatured);

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
  }


  Future<void> loadMore(
      {bool? isFeatured}) async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final isConnected = await _checkInternetConnection();
        if (!isConnected) {
          return;
        }

        final result = await publicationRepository.fetchPublications(
            page: ++state._currentPage,
            isFeatured: isFeatured);

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

  Future<List<PublicationModel>> _getPublicationsFromCache() async {
    final list = await publicationDataSource.getPublicationsByType(0);

    return list.map((item) => PublicationModel.fromEntity(item)).toList();
  }
}
