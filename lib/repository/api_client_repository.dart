import 'package:khub_mobile/api/config/client_config.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/controllers/auth_client.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';

abstract class ApiClientRepository {
  APIClient buildClient();
  AuthClient buildAuthClient();
}

class ApiClientRepositoryImpl extends ApiClientRepository {
  final PreferencesDatasource preferencesDatasource;

  ApiClientRepositoryImpl({required this.preferencesDatasource});

  @override
  APIClient buildClient() {
    final savedUrl =
        preferencesDatasource.getString(PreferencesDatasource.baseUrlKey);
    final baseUrl = savedUrl.isEmpty ? EnvConfig.baseUrl : savedUrl;

    final dio = initDio(baseUrl);
    return APIClient(dio);
  }

  @override
  AuthClient buildAuthClient() {
    final savedUrl =
        preferencesDatasource.getString(PreferencesDatasource.baseUrlKey);
    final baseUrl = savedUrl.isEmpty ? EnvConfig.baseUrl : savedUrl;

    final dio = initDio(baseUrl);
    return AuthClient(dio);
  }
}
