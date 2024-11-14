import 'dart:io';

import 'package:dio/dio.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/AiResponse.dart';
import 'package:khub_mobile/api/models/responses/PublicationsResponse.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class PublicationRepository {
  Future<DataState<PublicationsResponse>> fetchPublications({
    String? term,
    int? page,
    int? pageSize,
    int? author,
    int? subThemeId,
    int? themeId,
    bool? isFeatured,
    bool? orderByVisits,
    int? communityId,
    int? categoryId,
  });

  Future<DataState<PublicationsResponse>> fetchMyPublications({
    String? term,
    int? page,
    int? pageSize,
    int? subThemeId,
    int? themeId,
  });
  Future<DataState<PublicationsResponse>> fetchMyFavorites();

  Future<DataState<dynamic>> requestContent({
    required String title,
    required String description,
    int? countryId,
    String? email,
  });

  Future<DataState<dynamic>> createPublication(
      {required int resourceType,
      required int subTheme,
      required String title,
      required String description,
      required String? author,
      required int resourceCategory,
      required String link,
      required String communities,
      File? cover});

  Future<DataState<dynamic>> addPublicationComment(
      {required int publicationId, required String comment});

  Future<DataState<dynamic>> addFavoritePublication(
      {required int publicationId});

  Future<DataState<AiResponse>> summarizePublication(
      {required int resourceId,
      required int type,
      String? prompt,
      String? language});

  Future<DataState<AiResponse>> comparePublications({
    required int resourceId,
    required int otherResourceId,
    String? prompt,
  });
}

class PublicationRepositoryImpl extends PublicationRepository {
  final ApiClientRepository apiClientRepository;

  PublicationRepositoryImpl({required this.apiClientRepository});

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<PublicationsResponse>> fetchPublications(
      {String? term,
      int? page,
      int? pageSize,
      int? author,
      int? subThemeId,
      int? themeId,
      bool? isFeatured,
      bool? orderByVisits,
      int? communityId,
      int? categoryId}) async {
    try {
      Map<String, dynamic> request = {
        'page': page ?? EnvConfig.startPage,
        'page_size': pageSize ?? EnvConfig.pageSize
      };
      if (term != null) request['term'] = term;
      if (author != null) request['author'] = author;
      if (themeId != null) request['thematic_area_id'] = themeId;
      if (subThemeId != null) request['sub_thematic_area_id'] = subThemeId;
      if (isFeatured != null) request['is_featured'] = isFeatured;
      if (orderByVisits != null) request['order_by_visits'] = orderByVisits;
      if (communityId != null) request['community_id'] = communityId;
      if (categoryId != null) request['category'] = categoryId;

      final response = await _apiClient().filterPublications(request);

      // local
      // final result = await service.getObject('assets/data/publications.json');
      // final response = PublicationsResponse.fromJson(result);

      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState> createPublication(
      {required int resourceType,
      required int subTheme,
      required String title,
      required String description,
      required String? author,
      required int resourceCategory,
      required String link,
      required String communities,
      File? cover}) async {
    try {
      final response = await _apiClient().createPublication(
          resourceType: resourceType,
          subTheme: subTheme,
          title: title,
          description: description,
          communities: communities,
          link: link,
          cover: cover,
          resourceCategory: resourceCategory);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState> addPublicationComment(
      {required int publicationId, required String comment}) async {
    try {
      final response = await _apiClient().addPublicationComment(
          {'publication_id': publicationId, 'comment': comment});

      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState> addFavoritePublication({required int publicationId}) async {
    try {
      final response = await _apiClient().addFavoritePublication({
        'id': publicationId,
      });

      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<AiResponse>> summarizePublication(
      {required int resourceId,
      required int type,
      String? prompt,
      String? language}) async {
    try {
      Map<String, dynamic> request = {'resource_id': resourceId, 'type': type};

      if (prompt != null) request['prompt'] = prompt;
      if (language != null) request['language'] = language;

      final response = await _apiClient().summarizePublication(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<PublicationsResponse>> fetchMyPublications(
      {String? term,
      int? page,
      int? pageSize,
      int? subThemeId,
      int? themeId}) async {
    try {
      Map<String, dynamic> request = {
        'page': page ?? EnvConfig.startPage,
        'page_size': pageSize ?? EnvConfig.pageSize
      };
      if (term != null) request['term'] = term;
      if (subThemeId != null) request['sub_thematic_area_id'] = subThemeId;
      if (themeId != null) request['thematic_area_id'] = themeId;

      final response = await _apiClient().fetchMyPublications(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<PublicationsResponse>> fetchMyFavorites() async {
    try {
      final response = await _apiClient().fetchMyFavorites();
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState> requestContent(
      {required String title,
      required String description,
      int? countryId,
      String? email}) async {
    try {
      Map<String, dynamic> request = {
        'title': title,
        'description': description
      };

      if (email != null) request['email'] = email;
      if (countryId != null) request['country_id'] = countryId;

      final response = await _apiClient().requestContent(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<AiResponse>> comparePublications(
      {required int resourceId,
      required int otherResourceId,
      String? prompt}) async {
    try {
      Map<String, dynamic> request = {
        'resource_id': resourceId,
        'other_resource_id': otherResourceId,
      };

      if (prompt != null) request['prompt'] = prompt;

      final response = await _apiClient().comparePublications(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }
}
