import 'package:dio/dio.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/EventResponse.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class EventRepository {
  Future<DataState<EventResponse>> getEvents();
}

class EventRepositoryImpl implements EventRepository {
  final ApiClientRepository apiClientRepository;

  EventRepositoryImpl({required this.apiClientRepository});

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<EventResponse>> getEvents() async {
    try {
      final Map<String, dynamic> queries = {};
      final response = await _apiClient().getEvents(queries);
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataError(Helpers.resolveError(e));
    }
  }
}
