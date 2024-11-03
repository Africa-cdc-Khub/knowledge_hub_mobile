import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class TopPublicationState {
  String errorMessage = '';
  bool isSuccess = false;
  List<PublicationModel> publications = [];

  TopPublicationState();
  TopPublicationState.success(this.isSuccess, this.publications);
  TopPublicationState.error(this.isSuccess, this.errorMessage);
}

class TopSearchesViewModel extends ChangeNotifier {
  final PublicationRepository publicationRepository;

  TopSearchesViewModel(this.publicationRepository);

  Future<TopPublicationState> fetchTopPublications(
      {int page = 1, int pageSize = 5}) async {
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
          false, result.error ?? 'Error occurred');
    }

    return TopPublicationState();
  }
}