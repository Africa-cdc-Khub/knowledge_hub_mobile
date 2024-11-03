import 'package:dio/dio.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/UtilityResponse.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class CommunitiesRepository {
  Future<DataState<CommunityResponse>> fetchCommunities({
    String? term,
    int? page,
    int? pageSize,
  });
  Future<DataState<dynamic>> joinCommunity(int communityId, int userId);
  Future<DataState<dynamic>> leaveCommunity(int communityId, int userId);
}

class CommunitiesRepositoryImpl implements CommunitiesRepository {
  final ApiClientRepository apiClientRepository;

  CommunitiesRepositoryImpl({required this.apiClientRepository});

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<CommunityResponse>> fetchCommunities({
    String? term,
    int? page,
    int? pageSize,
  }) async {
    try {
      Map<String, dynamic> request = {
        'page': page ?? Config.startPage,
        'page_size': pageSize ?? Config.pageSize
      };
      if (term != null) request['term'] = term;

      final response = await _apiClient().fetchCommunityList(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<dynamic>> joinCommunity(int communityId, int userId) async {
    try {
      Map<String, dynamic> request = {
        'user_id': userId,
      };
      final response = await _apiClient().joinCommunity(communityId, request);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<dynamic>> leaveCommunity(int communityId, int userId) async {
    try {
      final response = await _apiClient().leaveCommunity(communityId, userId);
      return DataSuccess(response);
    } on DioException catch (err) {
      LOGGER.e(err);
      return DataError(Helpers.resolveError(err));
    }
  }
}
