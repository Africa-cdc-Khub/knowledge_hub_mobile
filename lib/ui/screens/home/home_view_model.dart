import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class HomeState {
  bool _loading = false;
  final String _errorMessage = '';
  List<PublicationModel> _publications = [];

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<PublicationModel> get publications => _publications;
}

class HomeViewModel extends ChangeNotifier {
  final PublicationRepository publicationRepository;
  final AuthRepository authRepository;

  HomeState state = HomeState();
  HomeState get getState => state;

  HomeViewModel(this.publicationRepository, this.authRepository);

  Future<void> fetchPublications(
      {String term = '',
      int page = 1,
      int pageSize = 10,
      bool? isFeatured}) async {
    state._loading = true;
    notifyListeners();

    final result = await publicationRepository.fetchPublications(
        term: term,
        page: page,
        pageSize: pageSize,
        isFeatured: isFeatured ?? false);

    if (result is DataSuccess) {
      state._loading = false;
      state._publications = result.data?.data
              ?.map((item) => PublicationModel.fromApiModel(item))
              .toList() ??
          [];
      notifyListeners();
    }

    if (result is DataError) {
      state._loading = false;
      notifyListeners();
    }
  }
}
