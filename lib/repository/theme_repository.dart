import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/theme_datasource.dart';
import 'package:khub_mobile/models/sub_theme_model.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';

abstract class ThemeRepository {
  Future<DataState<List<ThemeModel>>> fetchThemes();
  Future<DataState<List<SubThemeModel>>> fetchSubThemesByTheme(
      {required int themeId});
}

class ThemeRepositoryImpl extends ThemeRepository {
  final ApiClientRepository apiClientRepository;
  final ThemeDatasource themeDatasource;

  ThemeRepositoryImpl(
      {required this.apiClientRepository, required this.themeDatasource});

  APIClient get _apiClient => apiClientRepository.buildClient();

  @override
  Future<DataState<List<SubThemeModel>>> fetchSubThemesByTheme(
      {required int themeId}) async {
    try {
      final response = await _apiClient.getSubThemesByTheme(themeId);
      return DataSuccess(response.data?.data
              ?.map((item) => SubThemeModel.fromApiModel(item))
              .toList() ??
          []);
    } on Exception catch (err) {
      return DataError(err.toString());
    }
  }

  @override
  Future<DataState<List<ThemeModel>>> fetchThemes() async {
    try {
      // final response = await service.getObject('assets/data/themes.json');
      // List<dynamic> jsonList = response['data']['data'];
      // final list = jsonList.map((json) => ThemeApiModel.fromJson(json)).toList();
      final cachedThemes = await themeDatasource.getThemes();
      if (cachedThemes.isEmpty) {
        final response = await _apiClient.getThemes();
        final list = response.data?.data
                ?.map((item) => ThemeModel.fromApiModel(item))
                .toList() ??
            [];

        if (list.isNotEmpty) {
          await themeDatasource.saveThemes(list);
        }

        return DataSuccess(list);
      } else {
        return DataSuccess(cachedThemes);
      }
    } on Exception catch (err) {
      return DataError(err.toString());
    }
  }
}
