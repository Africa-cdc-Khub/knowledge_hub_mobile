import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/PublicationsResponse.dart';
import 'package:khub_mobile/cache/models/publication_entity.dart';
import 'package:khub_mobile/cache/publication_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class RecommendedPublicationState {
  String errorMessage = '';
  int errorType = 2;
  bool isSuccess = false;
  List<PublicationModel> publications = [];

  RecommendedPublicationState();
  RecommendedPublicationState.success(this.isSuccess, this.publications);
  RecommendedPublicationState.error(
      this.isSuccess, this.errorMessage, this.errorType);
}

class RecommendedPublicationViewModel extends ChangeNotifier {
  final PublicationRepository publicationRepository;
  final ConnectionRepository connectionRepository;
  final PublicationDataSource publicationDataSource;

  // HomeState state = HomeState();
  // HomeState get getState => state;

  RecommendedPublicationViewModel(this.publicationRepository,
      this.connectionRepository, this.publicationDataSource);

  Future<RecommendedPublicationState> fetchPublications(
      {int page = 1, int pageSize = 5, bool? isFeatured}) async {
    final isConnected = await connectionRepository.checkInternetStatus();

    if (!isConnected) {
      final cachedList = await _getPublicationsFromCache();
      return RecommendedPublicationState.success(true, cachedList);
    }

    return await _getRemotePublications(page, pageSize, isFeatured);
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
      int page, int pageSize, bool? isFeatured) async {
    final result = await publicationRepository.fetchPublications(
        page: page, pageSize: pageSize, isFeatured: isFeatured ?? false);

    if (result is DataSuccess) {
      final list = result.data?.data
              ?.map((item) => PublicationModel.fromApiModel(item))
              .toList() ??
          [];

      await clearPublicationsFromCache(); // Clear existing
      savePublicationsToCache(list); // Save new events
    }
    return result;
  }

  Future<RecommendedPublicationState> _getRemotePublications(
      int page, int pageSize, bool? isFeatured) async {
    final cached = await _getPublicationsFromCache();
    if (cached.isNotEmpty) {
      LOGGER.d('Getting cached publications');
      _fetchRemotePublications(
          page, pageSize, isFeatured); // Fetch remote to update cache
      return RecommendedPublicationState.success(true, cached);
    }

    LOGGER.d('Fetching remote publications');
    final result = await _fetchRemotePublications(page, pageSize, isFeatured);

    if (result is DataSuccess) {
      final list = result.data?.data
              ?.map((item) => PublicationModel.fromApiModel(item))
              .toList() ??
          [];
      return RecommendedPublicationState.success(true, list);
    }

    if (result is DataError) {
      return RecommendedPublicationState.error(
          false, result.error ?? 'Error occurred', 2);
    }

    return RecommendedPublicationState();
  }

  Future<List<PublicationModel>> _getPublicationsFromCache() async {
    final list = await publicationDataSource.getPublicationsByType(0);

    return list.map((item) => PublicationModel.fromEntity(item)).toList();
  }
}
