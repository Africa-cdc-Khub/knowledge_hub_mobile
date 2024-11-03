import 'package:flutter/foundation.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class PublicationListState {
  bool _loading = false;
  String _errorMessage = '';
  int _currentPage = Config.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;
  List<PublicationModel> _publications = [];

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<PublicationModel> get publications => _publications;
}

class PublicationListViewModel extends ChangeNotifier with SafeNotifier {
  final PublicationRepository publicationRepository;
  PublicationListState state = PublicationListState();
  PublicationListState get getState => state;

  PublicationListViewModel(this.publicationRepository);

  Future<void> fetchPublications(
      {int page = Config.startPage,
      bool? isFeatured,
      bool? orderByVisits,
      int? categoryId}) async {
    state._loading = true;
    state._publications = []; // reset
    state._currentPage = Config.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
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
