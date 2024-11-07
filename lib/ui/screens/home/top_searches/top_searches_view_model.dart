import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
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

  TopSearchesViewModel(this.publicationRepository, this.connectionRepository);

  Future<TopPublicationState> fetchTopPublications(
      {int page = 1, int pageSize = 5}) async {
    final isConnected = await connectionRepository.checkInternetStatus();

    if (!isConnected) {
      return TopPublicationState.error(false, 'No internet connection', 1);
    }

    final result = await publicationRepository.fetchPublications(
        page: page, pageSize: pageSize, orderByVisits: true);

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
}
