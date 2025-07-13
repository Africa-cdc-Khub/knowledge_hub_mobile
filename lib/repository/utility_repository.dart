import 'package:dio/dio.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/models/file_category_model.dart';
import 'package:khub_mobile/models/file_type_model.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/models/resource_model.dart';
import 'package:khub_mobile/models/settings_model.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class UtilityRepository {
  Future<DataState<List<FileTypeModel>>> fetchFileTypes();
  Future<DataState<List<FileCategoryModel>>> fetchFileCategories();
  Future<DataState<List<CommunityModel>>> fetchCommunities();
  Future<DataState<List<PreferenceModel>>> fetchPreferences();
  Future<DataState<List<JobModel>>> fetchJobs();
  Future<DataState<List<CountryModel>>> fetchCountries();
  Future<DataState<List<ResourceTypeModel>>> fetchResourceTypes();
  Future<DataState<List<ResourceCategoryModel>>> fetchResourceCategories();
  Future<DataState<SettingsModel>> fetchAppSettings();
  Future<void> saveAppSettings(SettingsModel model);
}

class UtilityRepositoryImpl implements UtilityRepository {
  final ApiClientRepository apiClientRepository;
  final UtilityDatasource utilityDatasource;
  final ColorThemeRepository colorThemeRepository;
  final ConnectionRepository connectionRepository;

  UtilityRepositoryImpl(
      {required this.utilityDatasource,
      required this.apiClientRepository,
      required this.colorThemeRepository,
      required this.connectionRepository});

  APIClient get _apiClient => apiClientRepository.buildClient();

  Future<bool> _checkInternetConnection() async {
    final isConnected = await connectionRepository.checkInternetStatus();
    return isConnected;
  }

  @override
  Future<DataState<List<FileTypeModel>>> fetchFileTypes() async {
    try {
      final response = await _apiClient.getFileTypes();
      return DataSuccess(response.data
              ?.map((item) => FileTypeModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<CommunityModel>>> fetchCommunities() async {
    try {
      final response = await _apiClient.getCommunities();
      return DataSuccess(response.data
              ?.map((item) => CommunityModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<FileCategoryModel>>> fetchFileCategories() async {
    try {
      final response = await _apiClient.getFileCategories();
      return DataSuccess(response.data
              ?.map((item) => FileCategoryModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<JobModel>>> fetchJobs() async {
    try {
      final response = await _apiClient.getJobs();
      return DataSuccess(
          response.data?.map((item) => JobModel.fromApiModel(item)).toList() ??
              []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<PreferenceModel>>> fetchPreferences() async {
    try {
      final response = await _apiClient.getPreferences();
      return DataSuccess(response.data
              ?.map((item) => PreferenceModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<CountryModel>>> fetchCountries() async {
    try {
      final response = await _apiClient.getMemberStates();
      return DataSuccess(response.data
              ?.map((item) => CountryModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<ResourceCategoryModel>>>
      fetchResourceCategories() async {
    try {
      final response = await _apiClient.getResourceCategories();
      return DataSuccess(response.data
              ?.map((item) => ResourceCategoryModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<List<ResourceTypeModel>>> fetchResourceTypes() async {
    try {
      final response = await _apiClient.getResourceTypes();
      return DataSuccess(response.data
              ?.map((item) => ResourceTypeModel.fromApiModel(item))
              .toList() ??
          []);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<SettingsModel>> fetchAppSettings() async {
    LOGGER.d('Fetching app settings...');
    try {
      final isConnected = await _checkInternetConnection();
      if (!isConnected) {
        DataError('No internet connection');
      }

      final response = await _apiClient.getAppSettings();
      final settings = SettingsModel.fromApiModel(response.data!);

      await utilityDatasource.saveSetting(settings);
      await saveAppSettings(settings);

      return DataSuccess(settings);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<void> saveAppSettings(SettingsModel model) async {
    try {
      await utilityDatasource.saveSetting(model);
      await colorThemeRepository.saveThemeColors(
          model.primaryColor, model.primaryColor);
    } on Exception catch (err) {
      LOGGER.d(err);
    }
  }
}
