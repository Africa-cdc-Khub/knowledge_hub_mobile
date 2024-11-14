import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/courses/courses_api_model.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';

abstract class CoursesRepository {
  Future<DataState<CoursesResponse>> fetchCourses({
    int? page,
    int? pageSize,
  });
}

class CoursesRepositoryImpl implements CoursesRepository {
  final ApiClientRepository apiClientRepository;

  CoursesRepositoryImpl(this.apiClientRepository);

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<CoursesResponse>> fetchCourses({
    int? page,
    int? pageSize,
  }) async {
    try {
      Map<String, dynamic> request = {
        'page': page ?? EnvConfig.startPage,
        'page_size': pageSize ?? EnvConfig.pageSize
      };
      final response = await _apiClient().getCourses(request);

      return DataSuccess(response);
    } on Exception catch (err) {
      return DataError(err.toString());
    }
  }
}
