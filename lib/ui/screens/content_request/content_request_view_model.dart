import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class ContentRequestState {
  final bool _loading = false;
  final bool _isLoggedIn = false;

  bool isSuccess = false;
  String errorMessage = '';
  dynamic response;

  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;

  ContentRequestState();
  ContentRequestState.success(this.isSuccess, this.response);
  ContentRequestState.error(this.isSuccess, this.errorMessage);
}

class ContentRequestViewModel extends ChangeNotifier {
  ContentRequestState state = ContentRequestState();

  ContentRequestState get getState => state;

  final PublicationRepository publicationRepository;

  ContentRequestViewModel({required this.publicationRepository});

  Future<ContentRequestState> submitRequest(
      {required String title,
      required String description,
      String? email,
      int? countryId}) async {
    final result = await publicationRepository.requestContent(
      title: title,
      description: description,
      email: email,
      countryId: countryId,
    );

    if (result is DataSuccess) {
      return ContentRequestState.success(true, result.data);
    }

    if (result is DataError) {
      return ContentRequestState.error(false, result.error ?? '');
    }

    return ContentRequestState();
  }
}
