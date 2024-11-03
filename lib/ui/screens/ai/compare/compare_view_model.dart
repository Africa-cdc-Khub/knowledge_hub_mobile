import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class CompareState {
  bool isSuccess = false;
  String errorMessage = '';
  String content = '';
  PublicationModel? publicationOne;
  PublicationModel? publicationTwo;

  CompareState();
  CompareState.success(this.isSuccess, this.content);
  CompareState.error(this.isSuccess, this.errorMessage);
}

class CompareViewModel extends ChangeNotifier with SafeNotifier {
  final CompareState _state = CompareState();
  CompareState get state => _state;

  final PublicationRepository publicationRepository;

  CompareViewModel(this.publicationRepository);

  Future<CompareState> comparePublications({String? prompt}) async {
    if (_state.publicationOne == null || _state.publicationTwo == null) {
      return CompareState.error(
          false, 'Please select two publications to compare');
    }

    final result = await publicationRepository.comparePublications(
        resourceId: _state.publicationOne!.id,
        otherResourceId: _state.publicationTwo!.id,
        prompt: prompt);

    if (result is DataSuccess) {
      final response = result.data!;
      return CompareState.success(true, response.content);
    }

    if (result is DataError) {
      return CompareState.error(false, result.error ?? '');
    }

    return CompareState();
  }

  void setPublicationOne(PublicationModel? publication) {
    _state.publicationOne = publication;
    safeNotifyListeners();
  }

  void setPublicationTwo(PublicationModel? publication) {
    _state.publicationTwo = publication;
    safeNotifyListeners();
  }
}
