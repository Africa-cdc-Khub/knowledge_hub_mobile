import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
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

  // HomeState state = HomeState();
  // HomeState get getState => state;

  RecommendedPublicationViewModel(
      this.publicationRepository, this.connectionRepository);

  Future<RecommendedPublicationState> fetchPublications(
      {int page = 1, int pageSize = 5, bool? isFeatured}) async {
    final isConnected = await connectionRepository.checkInternetStatus();

    if (!isConnected) {
      return RecommendedPublicationState.error(
          false, 'No internet connection', 1);
    }

    final result = await publicationRepository.fetchPublications(
        page: page, pageSize: pageSize, isFeatured: isFeatured ?? false);

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
}
