import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class MyPublicationsState {
  bool _loading = false;
  String _errorMessage = '';
  int _currentPage = EnvConfig.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;
  List<PublicationModel> _publications = [];

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<PublicationModel> get publications => _publications;
}

class MyPublicationsViewModel extends ChangeNotifier with SafeNotifier {
  MyPublicationsState state = MyPublicationsState();
  MyPublicationsState get getState => state;

  late final PublicationRepository publicationRepository;

  MyPublicationsViewModel(this.publicationRepository);

  Future<void> fetchPublications() async {
    state._loading = true;
    state._publications = []; // reset
    state._currentPage = EnvConfig.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
      final result = await publicationRepository.fetchMyPublications();

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

  Future<void> loadMore({bool? isFeatured, bool? orderByVisits}) async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final result = await publicationRepository.fetchPublications(
            page: ++state._currentPage,
            isFeatured: isFeatured,
            orderByVisits: orderByVisits);

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
  }
}
