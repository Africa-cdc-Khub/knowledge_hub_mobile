import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/PublicationsResponse.dart';
import 'package:khub_mobile/cache/models/publication_entity.dart';
import 'package:khub_mobile/cache/publication_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class TopPublicationState {
  String errorMessage = '';
  bool isSuccess = false;
  List<PublicationModel> publications = [];
  int errorType = 2;

  TopPublicationState();
  TopPublicationState.success(this.isSuccess, this.publications);
  TopPublicationState.error(this.isSuccess, this.errorMessage, this.errorType);
}

class TopSearchesViewModel extends ChangeNotifier {
  final PublicationRepository publicationRepository;
  final ConnectionRepository connectionRepository;
  final PublicationDataSource publicationDataSource;

  TopSearchesViewModel(this.publicationRepository, this.connectionRepository,
      this.publicationDataSource);

  Future<TopPublicationState> fetchTopPublications(
      {int page = 1, int pageSize = 5}) async {
    final isConnected = await connectionRepository.checkInternetStatus();

    if (!isConnected) {
      final cachedList = await _getPublicationsFromCache();
      return TopPublicationState.success(true, cachedList);
    }

    return _getRemotePublications(page, pageSize, true);
  }

  Future<void> clearPublicationsFromCache() async {
    await publicationDataSource.deletePublications(1);
  }

  Future<void> savePublicationsToCache(
      List<PublicationModel> publications) async {
    final list = publications
        .map((item) => PublicationEntity.fromModel(item, 1))
        .toList();
    await publicationDataSource.savePublications(list);
  }

  Future<DataState<PublicationsResponse>> _fetchRemotePublications(
      int page, int pageSize, bool orderByVisits) async {
    final result = await publicationRepository.fetchPublications(
        page: page, pageSize: pageSize, orderByVisits: orderByVisits);

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

  Future<TopPublicationState> _getRemotePublications(
      int page, int pageSize, bool orderByVisits) async {
    final cached = await _getPublicationsFromCache();
    if (cached.isNotEmpty) {
      LOGGER.d('Getting cached publications');
      _fetchRemotePublications(
          page, pageSize, orderByVisits); // Fetch remote to update cache
      return TopPublicationState.success(true, cached);
    }

    LOGGER.d('Fetching remote publications');
    final result =
        await _fetchRemotePublications(page, pageSize, orderByVisits);

    if (result is DataSuccess) {
      final list = result.data?.data
              ?.map((item) => PublicationModel.fromApiModel(item))
              .toList() ??
          [];
      return TopPublicationState.success(true, list);
    }

    if (result is DataError) {
      return TopPublicationState.error(
          false, result.error ?? 'Error occurred', 2);
    }

    return TopPublicationState();
  }

  Future<List<PublicationModel>> _getPublicationsFromCache() async {
    final list = await publicationDataSource.getPublicationsByType(1);
    return list.map((item) => PublicationModel.fromEntity(item)).toList();
  }
}
