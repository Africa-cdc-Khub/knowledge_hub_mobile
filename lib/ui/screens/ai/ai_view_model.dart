import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/forum_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';

class AiState {
  bool isSuccess = false;
  String errorMessage = '';
  String content = '';

  AiState();
  AiState.success(this.isSuccess, this.content);
  AiState.error(this.isSuccess, this.errorMessage);
}

class AiViewModel extends ChangeNotifier {
  final PublicationRepository publicationRepository;
  final ForumRepository forumRepository;

  AiViewModel(this.publicationRepository, this.forumRepository);

  final state = AiState();

  Future<AiState> summarizePublication(
      {required int resourceId,
      required int type,
      String? prompt,
      String? language}) async {
    final result = await publicationRepository.summarizePublication(
        resourceId: resourceId, type: type, prompt: prompt, language: language);

    if (result is DataSuccess) {
      final response = result.data!;
      return AiState.success(true, response.content);
    }

    if (result is DataError) {
      return AiState.error(false, result.error ?? '');
    }

    return AiState();
  }
}
