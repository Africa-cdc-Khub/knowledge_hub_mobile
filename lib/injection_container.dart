import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:khub_mobile/cache/events_datasource.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/cache/publication_datasource.dart';
import 'package:khub_mobile/cache/theme_datasource.dart';
import 'package:khub_mobile/cache/user_datasource.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';
import 'package:khub_mobile/repository/communities_repository.dart';
import 'package:khub_mobile/repository/connection_repository.dart';
import 'package:khub_mobile/repository/courses_repository.dart';
import 'package:khub_mobile/repository/event_repository.dart';
import 'package:khub_mobile/repository/forum_repository.dart';
import 'package:khub_mobile/repository/notifications_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/repository/theme_repository.dart';
import 'package:khub_mobile/repository/utility_repository.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
final LOGGER = Logger();

Future<void> init() async {
  LOGGER.d('Initializing DI');

// Repositories
  getIt.registerLazySingleton<PublicationRepository>(
      () => PublicationRepositoryImpl(apiClientRepository: getIt()));
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(
      apiClientRepository: getIt(), themeDatasource: getIt()));
  getIt.registerLazySingleton<ForumRepository>(
      () => ForumRepositoryImpl(getIt()));
  getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(apiClientRepository: getIt()));
  getIt.registerLazySingleton<ColorThemeRepository>(
      () => ColorThemeRepositoryImpl(preferences: getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      colorThemeRepository: getIt(),
      preferences: getIt(),
      apiClientRepository: getIt(),
      userDatasource: getIt()));
  getIt.registerLazySingleton<UtilityRepository>(() => UtilityRepositoryImpl(
      apiClientRepository: getIt(),
      colorThemeRepository: getIt(),
      utilityDatasource: getIt(),
      connectionRepository: getIt()));
  getIt.registerLazySingleton<CommunitiesRepository>(
      () => CommunitiesRepositoryImpl(apiClientRepository: getIt()));
  getIt.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(apiClientRepository: getIt()));
  getIt.registerLazySingleton<CoursesRepository>(
      () => CoursesRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ApiClientRepository>(
      () => ApiClientRepositoryImpl(preferencesDatasource: getIt()));
  getIt.registerLazySingleton<ConnectionRepository>(
      () => ConnectionRepositoryImpl());

  // Data sources
  getIt.registerLazySingleton<UtilityDatasource>(
      () => UtilityDatasourceImpl(preferences: getIt()));
  getIt.registerLazySingleton<UserDatasource>(() => UserDatasourceImpl());
  getIt.registerLazySingleton<ThemeDatasource>(() => ThemeDataSourceImpl());
  getIt.registerLazySingleton<EventsDatasource>(() => EventsDataSourceImpl());
  getIt.registerLazySingleton<PreferencesDatasource>(
      () => PreferencesDatasourceImpl(preferences: getIt()));
  getIt.registerLazySingleton<PublicationDataSource>(
      () => PublicationDataSourceImpl());

// External Libs
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Logger());

  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
      () => GlobalKey<NavigatorState>());

  // API
  // final baseUrl = await _getBaseUrl();
  // getIt.registerLazySingleton<Dio>(() => initDio(baseUrl));
  // getIt.registerLazySingleton<APIClient>(() => APIClient(getIt()));
  // getIt.registerLazySingleton<AuthClient>(() => AuthClient(getIt()));
}

// Future<String> _getBaseUrl() async {
//   final pref = await SharedPreferences.getInstance();
//   final savedUrl = pref.getString(PreferencesDatasource.baseUrlKey);

//   return savedUrl ?? Config().baseUrl;
// }
