import 'dart:io';

import 'package:dio/dio.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/ForumsResponse.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class ForumRepository {
  Future<DataState<ForumsResponse>> fetchForums({
    String? term,
    int? page,
    int? pageSize,
    int? communityId,
  });
  Future<DataState<dynamic>> createForum({
    required String title,
    required String description,
    required File? image,
  });

  Future<DataState> addForumComment(
      {required int forumId, required String comment});
}

class ForumRepositoryImpl implements ForumRepository {
  final ApiClientRepository apiClientRepository;

  ForumRepositoryImpl(this.apiClientRepository);

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<ForumsResponse>> fetchForums({
    String? term,
    int? page,
    int? pageSize,
    int? communityId,
  }) async {
    try {
      // final result = await service.getObject('assets/data/forums.json');
      // final ForumsResponse response = ForumsResponse.fromJson(result);

      Map<String, dynamic> request = {
        'page': page ?? EnvConfig.startPage,
        'page_size': pageSize ?? EnvConfig.pageSize
      };

      if (term != null) request['term'] = term;
      if (communityId != null) request['community_id'] = communityId;
      final response = await _apiClient().getForums(request);

      return DataSuccess(response);
    } on Exception catch (err) {
      return DataError(err.toString());
    }
  }

  @override
  Future<DataState<dynamic>> createForum({
    required String title,
    required String description,
    File? image,
  }) async {
    try {
      final response = await _apiClient()
          .createForum(title: title, image: image, description: description);

      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState> addForumComment(
      {required int forumId, required String comment}) async {
    try {
      final response = await _apiClient()
          .addForumComment({'id': forumId, 'comment': comment});

      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }
}
